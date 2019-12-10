//
//  MainWindowController.swift
//  clipboard
//
//  Created by wyy on 2019/12/9.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

class MainWindowController : NSWindowController, NSWindowDelegate{
    override func windowDidLoad() {
        self.window?.level = .floating
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.makeMain()
        self.window?.delegate = self
    }
    
    override func keyDown(with event: NSEvent) {
        let mask = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if mask == [.command] {
            if event.characters == "q" {
                AppDelegate.quit()
                return
            }
            if event.characters == "w" {
                self.window?.close()
                return
            }
        }
    }
}
