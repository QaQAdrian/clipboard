//
// Created by wyy on 2019/12/3.
// Copyright (c) 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

class ClipboardOSX: Clipboard {
    private static let ImageURL: URL? = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if urls.count < 0 {
            print("document dir is not exists")
            return nil
        }
        return urls[0]
    }()

    private static func saveImage(date: Date, image: Data) -> URL? {
        if let url = ClipboardOSX.ImageURL?.appendingPathComponent("\(date.timeIntervalSince1970).png") {
            do {
                try image.write(to: url)
                return url
            } catch {
                print("write image error \(error)")
            }
        }
        return nil
    }

    // 创建图片文件并保存URL
    init?(image: Data) {
        let date = Date()
        if let url = ClipboardOSX.saveImage(date: date, image: image) {
            super.init(type: CType.IMAGE, createDate: date, url: url)
            return
        }
        return nil
    }

    init(content: String, html: String?) {
        super.init(content: content, contentWithFormat: html, type: CType.HTML)
    }

    init(content: String) {
        super.init(content: content, type: CType.STR)
    }

    init(fileUrl: URL) {
        super.init(content: fileUrl.lastPathComponent.removingPercentEncoding ?? "", type: CType.FILE, url: fileUrl)
    }

    func getNSImage() -> NSImage? {
        guard self.type == Clipboard.CType.IMAGE && self.url != nil else {
            return nil
        }
        return NSImage(contentsOf: self.url!)
    }
    
    func showImage() -> NSImage? {
        var image: NSImage?
        switch self.type {
        case .STR: image = NSImage(named: "text")
        case .FILE: image = NSImage(named: "floder")
        case .HTML: image = NSImage(named: "text")
        case .IMAGE: image = self.getNSImage()
        case .URL: image = NSImage(named: "floder")
        }
        return image
    }
    
    func showContent() -> String {
        var str: String?
        switch self.type {
        case .STR: str = self.content
        case .FILE: str = self.url?.absoluteString
        case .HTML: str = self.content
        case .IMAGE: str = self.url?.absoluteString
        case .URL: str = self.url?.absoluteString
        }
        return str ?? ""
    }
    
    func copy() {
        switch self.type {
        case .IMAGE:
            if let url = self.url {
                ClipboardListener.shared.copyImage(NSImage(contentsOf: url))
            }
        case .URL: fallthrough
        case .FILE:
            if let url = self.url {
                ClipboardListener.shared.copyFile(url)
            }
        case .STR: fallthrough
        case .HTML:
            if let content = self.content {
                ClipboardListener.shared.copy(content)
            }
        }
    }
}

// MARK: ClipboardItems

typealias ClipboardItems = [ClipboardOSX]
extension ClipboardItems {
    func hasSame(_ other: Clipboard) -> Bool {
        return self.first(where: {$0.isSameContent(other)}) != nil
    }
    
    mutating func appendExcludeSame(_ other: ClipboardOSX) -> Bool {
        if self.hasSame(other) {
            return false
        }
        self.append(other)
        return true
    }
}

