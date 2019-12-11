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

    @IBOutlet var openBtn: NSButton! {
        didSet {
            checkBtnStatus()
        }
    }

    @IBOutlet var copyBtn: NSButton! {
        didSet {
            checkBtnStatus()
        }
    }

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
//    @IBOutlet var textView: NSTextField!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textScrollView: NSScrollView!
    
    var needImage = true {
        didSet {
            imageView.isHidden = !needImage
            textScrollView.isHidden = needImage
        }
    }
    
    func checkBtnStatus() {
        if self.item == nil {
            openBtn?.isHidden = true
            copyBtn?.isHidden = true
            return
        }
        if let existItem = self.item {
            copyBtn?.isHidden = false
            openBtn?.isHidden = existItem.showType == .STR
        }
        //TODO: 暂时不要拷贝
        copyBtn?.isHidden = true
    }
    
    func refresh() {
        checkBtnStatus()
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
            imageView.image = item?.showImage() ?? NSImage(named: "empty")
            
//            imageView.layer = imageView.layer ?? CALayer();
//            imageView.layer?.contentsGravity = .resize;
//            imageView.layer?.contents = item?.showImage() ?? NSImage(named: "empty");
//            imageView.wantsLayer = true;
        } else {
            textView.string = item?.showContent() ?? ""
//            textView.stringValue =
        }
    }
}
