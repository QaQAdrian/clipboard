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
    override func viewDidLoad() {
        super.viewDidLoad()
        expandRight = UserDefaults.standard.bool(forKey: "expandRight")
        if self.expandRight {
            expandRightView()
        } else {
            collapsedRightView()
        }
    }
    
    private var expandRight: Bool = false {
        didSet {
            UserDefaults.standard.set(expandRight, forKey: "expandRight")
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
