//
//  PreviewController.swift
//  clipboard
//
//  Created by wyy on 2019/12/9.
//  Copyright © 2019 yahaha. All rights reserved.
//

import AppKit
import Foundation

class PreviewController: NSViewController {
    var item: ClipboardOSX? {
        didSet {
            refresh()
        }
    }

    @IBAction func copy(_ sender: Any) {
        item?.copy()
    }

    @IBOutlet var openBtn: NSButton!
    @IBAction func open(_ sender: Any) {
        if let url = item?.url {
            NSWorkspace.shared.open(url)
        }
    }

    @IBOutlet var previewView: NSView!
    override func viewDidLoad() {
        let constraints = [self.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 450)]
        NSLayoutConstraint.activate(constraints)
        refresh()
    }

    @IBOutlet var imageView: NSImageView!
    @IBOutlet var textView: NSTextField!

    var needImage = true {
        didSet {
            imageView.isHidden = !needImage
            textView.isHidden = needImage
        }
    }
    func refresh() {
        var need = true
        switch item?.type {
        case .STR: need = false
        case .HTML: need = false
        case .FILE: break
        case .IMAGE: break
        case .URL: break
        case .none: break
        }
        needImage = need
        if needImage {
            imageView.image = item?.getNSImage()
        } else {
            textView.stringValue = item?.showContent() ?? ""
        }
    }
}
