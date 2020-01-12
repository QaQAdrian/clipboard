//
//  ListTextItem.swift
//  widget
//
//  Created by wyy on 2019/12/8.
//  Copyright © 2019 yahaha. All rights reserved.
//

import AppKit
import Foundation

class ClickTextField: NSTextField {
}

class ListTextItem: NSView {
    // MARK: property

    @IBOutlet var elapse: NSTextField!
    @IBOutlet var text: NSTextField! {
        didSet {
            self.text.lineBreakMode = .byCharWrapping
        }
    }
    @IBOutlet var image: NSImageView!

    @IBOutlet var previewBtn: NSButton!

    var itemId: String?
    var storyboard: NSStoryboard?
    var tableView: NSTableView?
    var item: ClipboardOSX?
    var click: ((ClipboardOSX?, ListTextItem) -> Void)?
    var closePreview: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }
    
    // 改变鼠标指针
    override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: NSCursor.pointingHand)
    }
    // MARK: event
    @IBAction func preview(_ sender: NSButton) {
        if let controller = getPreviewController() {
            controller.item = item
            let popover = NSPopover()
            popover.contentViewController = controller
            popover.behavior = .transient
            popover.show(relativeTo: self.visibleRect, of: self, preferredEdge: .maxY)
        }
    }

    override func mouseDown(with event: NSEvent) {
    }

    override func mouseUp(with event: NSEvent) {
        if let hook = click {
            hook(item, self)
        }
    }
    
    private func getPreviewController() -> PreviewController? {
        let controller = storyboard?.instantiateController(withIdentifier: "PreviewController") as? PreviewController
        print(controller?.view == nil)
        return controller
    }

    
    // MARK: setter

    func setImage(image: NSImage?) {
        self.image.image = image
    }

    func setText(content: String?) {
        text?.stringValue = content ?? ""
    }

    func setElapse(createDate: Date?) {
        if createDate == nil {
            elapse?.stringValue = ""
            return
        }
        let date = createDate!
        if let (n, unit) = date.elapsedEssentially() {
            let i = n == 0 ? 1 : n
            if i > 0 {
                let unitStr: String
                switch unit {
                case .hour: unitStr = "hour".localized
                case .minute: unitStr = "minute".localized
                case .second:
                    elapse?.stringValue = "just now".localized
                    return
                
                case .day: unitStr = "day".localized
                default:
                    elapse.stringValue = date.toLocalString()
                    return
                }
                elapse?.stringValue = "\(i) \(unitStr)\(i == 1 ? "" : "s".localized)\("ago".localized)"
                return
            }
        }
        elapse?.stringValue = date.toLocalString()
    }
}
