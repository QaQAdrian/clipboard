//
//  Notice.swift
//  clipboard
//
//  Created by wyy on 2020/1/10.
//  Copyright © 2020 yahaha. All rights reserved.
//

import Foundation
import AppKit

class Notice: NSView, CAAnimationDelegate {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true;
        if let layer = self.layer {
            layer.cornerRadius = 10
        }
    }
    
    func start() {
        if OSXUtils.isDarkMod() {
            self.layer?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            self.layer?.backgroundColor = #colorLiteral(red: 0.9547311664, green: 0.9490554929, blue: 0.9590938687, alpha: 1)
        }
        self.isHidden = false
        let animation = CATransition()
        animation.delegate = self
        animation.type = .push
        animation.duration = 0.3
        animation.subtype = .fromTop
        animation.isRemovedOnCompletion = true
        layer?.add(animation, forKey: "animatePush")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: {_ in self.isHidden = true})
    }
}
