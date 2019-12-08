//
//  FadeView.swift
//  widget
//
//  Created by wyy on 2019/12/8.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

class FadeView: NSView, CAAnimationDelegate {
    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.setFill()
        dirtyRect.fill()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _ = initLayer
    }

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
        layer?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2387093322)
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
    
//    func transition() {
//        self.resetFrame()
////        self.alphaValue = 1
//        let transition = CATransition()
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
//        transition.duration = 3
//        transition.delegate = self
////        transition.fillMode = .forwards
//        transition.isRemovedOnCompletion = false
//        transition.type = .fade //推送类型
//        transition.subtype = .fromBottom
//        self.layer?.add(transition, forKey: "transitionFadeIO")
//    }
    
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
