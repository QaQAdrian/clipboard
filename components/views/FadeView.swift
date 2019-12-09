//
//  FadeView.swift
//  widget
//
//  Created by wyy on 2019/12/8.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

@IBDesignable
class FadeView: NSView, CAAnimationDelegate {
    @IBOutlet var image: NSImageView!

    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.setFill()
        dirtyRect.fill()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _ = initLayer
    }

    // TODO: init image
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _ = initLayer
    }
    
    private lazy var initLayer:() = {
        self.alphaValue = 0
        self.wantsLayer = true
        if self.layer == nil {
            self.layer = CALayer()
        }
        layer?.frame = frame
        layer?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }()

    func resetFrame() {
        if let parentView = self.superview?.frame {
            self.frame = parentView
        }
    }
    
    func start() {
        self.resetFrame()
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.delegate = self
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer?.add(animation, forKey: "animateFadeIO")
    }
    
    // 防止事件 （accepet responder）
    override func keyUp(with event: NSEvent) {
        
    }
    override func keyDown(with event: NSEvent) {
        
    }
    override func mouseUp(with event: NSEvent) {
        
    }
    override func mouseDown(with event: NSEvent) {
        
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: {_ in
            print("remove \(Date())")
            self.removeFromSuperview()
        })
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print("started")
    }
}
