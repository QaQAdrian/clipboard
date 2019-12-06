//
//  NSButtonView.swift
//  widget
//
//  Created by wyy on 2019/12/5.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

//https://www.iconfont.cn/search/index?q=add
class IconBtn: NSButton {
    var itemId: String?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.isBordered = false
        self.target = self
        self.isEnabled = true
        self.setButtonType(NSButton.ButtonType.momentaryChange)
        self.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class RemoveBtn: IconBtn {
    private static var image: NSImage? = NSImage(named: "remove")
    private static var activeImage: NSImage? = NSImage(named: "remove-active")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.image = RemoveBtn.image
        self.alternateImage = RemoveBtn.activeImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PasteBtn: IconBtn {
    private static var image: NSImage? = NSImage(named: "paste")
    private static var activeImage: NSImage? = NSImage(named: "paste-active")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.image = PasteBtn.image
        self.alternateImage = PasteBtn.activeImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
