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
    private var checkMarkView: FadeView? = FadeView.createFromNib("FadeView")

    var itemId: String?
    var item: ClipboardOSX?
    var click: ((ClipboardOSX?, ListTextItem) -> Void)?
    var preview: ((ClipboardOSX?) -> Void)?
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

    private var previewIcon = false {
        didSet {
            if previewIcon {
                if let hook = preview {
                    hook(item)
                }
            } else {
                if let hook = closePreview {
                    hook()
                }
            }
        }
    }
    // MARK: event

    @IBAction func preview(_ sender: NSButton) {
        previewIcon = !previewIcon
    }

    override func mouseDown(with event: NSEvent) {
    }

    override func mouseUp(with event: NSEvent) {
        if let hook = click {
            hook(item, self)
        }
    }

    func showCheckMark() {
//        checkMarkView = FadeView.createFromNib("FadeView")
        if let exists = checkMarkView {
            addSubview(exists)
            checkMarkView?.start()
        }
    }
    
    func removeCheckMarkView() {
        if let checkMark = checkMarkView {
            checkMark.removeFromSuperview()
        }
    }

    override func awakeFromNib() {
        
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
