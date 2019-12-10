//
//  clipboard.swift
//  clipboard
//
//  Created by wyy on 2019/12/2.
//  Copyright © 2019 yahaha. All rights reserved.
//

import AppKit
import Foundation

class ClipboardListener {
    typealias Hook = (ClipboardOSX) -> Void
    typealias PasteType = NSPasteboard.PasteboardType
    
    static let shared = {
        ClipboardListener()
    }()

    private let availableType = [
        PasteType.fileURL,
        PasteType.tiff,
        PasteType.html,
        PasteType.string
    ]

    private var stopped = false
    private let pasteboard = NSPasteboard.general
    private let timerInterval = 1.0

    private var changeCount: Int
    private var hooks: [Hook]

    private init() {
        changeCount = pasteboard.changeCount
        hooks = []
    }

    func onNewCopy(_ hook: @escaping Hook) {
        hooks.append(hook)
    }

    func startListening() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            DispatchQueue.global().async {
                self.checkForChangesInPasteboard()
            }
        })
    }

    func copy(_ string: String?) {
        if let content = string {
            pasteboard.clearContents()
            pasteboard.declareTypes([PasteType.string], owner: nil)
            pasteboard.setString(content, forType: PasteType.string)
        }
    }
    
    func copyFile(_ url: URL?) {
        if let exist = url {
            pasteboard.clearContents()
            pasteboard.setData(exist.absoluteString.data(using: .utf8), forType: .fileURL)
        }
    }

    func copyImage(_ image: NSImage?) {
        if let data = image?.tiffRepresentation {
            pasteboard.clearContents()
            pasteboard.setData(data, forType: .tiff)
        }
    }

    func start() {
        self.stopped = false
    }
    func stop() {
        self.stopped = true
    }

    // 检查新拷贝项并保存
    private func checkForChangesInPasteboard() {
        // 是否有新拷贝项
        guard pasteboard.changeCount != changeCount else {
            return
        }
        changeCount = pasteboard.changeCount
        if self.stopped {
            return
        }
        // 获取拷贝类型和内容 （可能并不是线程安全的）
        let availableType = pasteboard.availableType(from: self.availableType)
        guard availableType != nil else {
            return
        }
        let type = availableType!;
        let content = pasteboard.string(forType: .string)
        // 不需要获取data
        let data = pasteboard.data(forType: type)
        if let instance = parse(content: content, data: data, type: type) {
            for hook in hooks {
                hook(instance)
            }
        }
    }

    private func parse(content: String?, data: Data?, type: PasteType) -> ClipboardOSX? {
        var clipboard: ClipboardOSX?
        switch type {
        case PasteType.fileURL:
            let url = data.flatMap({ d in String(data: d, encoding: .utf8) })
            if let exists = url, let existURL = URL(string:exists) {
                clipboard = ClipboardOSX(fileUrl: existURL)
            }
            break
        case PasteType.tiff:
            clipboard = data.flatMap {
                ClipboardOSX(image: $0)
            }
            break
        case PasteType.html:
            let format = data.flatMap({ d in String(data: d, encoding: .utf8) })
            clipboard = content.map {
                ClipboardOSX(content: $0, html: format ?? $0)
            }
            break
        case PasteType.string:
            clipboard = content.map {
                ClipboardOSX(content: $0)
            }
            break
        default: print("unsupported type \(type)")
        }
        return clipboard
    }
}
