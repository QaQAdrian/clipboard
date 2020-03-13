//
//  StatusBar.swift
//  clipboard
//
//  Created by wyy on 2019/12/10.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

class Menu: NSMenu {
    @IBOutlet var startBtn: NSMenuItem!
    @IBOutlet var stopBtn: NSMenuItem!
    
    @IBAction func start(_ sender: Any) {
        stopBtn.isHidden = false
        startBtn.isHidden = true
        ClipboardListener.shared.start()
    }
    
    @IBAction func stop(_ sender: NSMenuItem) {
        stopBtn.isHidden = true
        startBtn.isHidden = false
        ClipboardListener.shared.stop()
    }
    
    @IBAction func openWindow(_ sender: NSMenuItem) {
        AppDelegate.openMainWindow()
    }
    
    @IBAction func openSetting(_ sender: Any) {
    }
    
    @IBAction func giveMark(_ sender: Any) {
    }
    
    @IBAction func feedback(_ sender: Any) {
    }
    
    @IBAction func quit(_ sender: Any) {
        AppDelegate.quit()
    }
}

class StatusBar {
    private lazy var menuIcon: NSStatusItem? = {
        let flag = OSXUtils.isDarkMode()
        if let image = flag ? NSImage(named: "clipboard") : NSImage(named: "clipboardBlack") {
            let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            image.size = NSMakeSize(18.0, 18.0);
            item.image = image
            item.button?.performClick(#selector(buttonAction))
            return item
        }
       return nil
    }()
    
    @objc func buttonAction(sender: Any!) {
        AppDelegate.openMainWindow()
    }

    init(_ menu: Menu) {
        self.menuIcon?.menu = menu
    }
    
}
