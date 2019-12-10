//
//  SplitViewController.swift
//  clipboard
//
//  Created by wyy on 2019/12/9.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

class SplitViewController: NSSplitViewController {
    
    private var expandRight: Bool = true {
        didSet {
            if self.expandRight {
                expandRightView()
            } else {
                collapsedRightView()
            }
        }
    }
    
    func expand() {
        expandRight = !expandRight
    }
    
    func expandRightView(){
        let rightView = self.splitView.subviews[1]
        rightView.isHidden = false
        //重新刷新显示
        self.splitView.display()
    }
    
    func collapsedRightView(){
        let rightView = self.splitView.subviews[1]
        rightView.isHidden = true
        self.splitView.display()
    }
}
