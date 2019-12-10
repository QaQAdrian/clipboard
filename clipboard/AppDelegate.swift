//
//  AppDelegate.swift
//  clipboard
//
//  Created by wyy on 2019/12/2.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let clipboard = ClipboardListener.shared
    var iStatucBar: StatusBar?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        clipboard.startListening()
        iStatucBar = StatusBar()
        print("status bar \(iStatucBar != nil)")
        NSApp.setActivationPolicy(.regular)
    }

    static func openMainWindow() {
        let app = NSApplication.shared
        app.activate(ignoringOtherApps: true)
        for window in app.windows {
            if window.windowController is MainWindowController {
                window.makeKeyAndOrderFront(self)
                return
            }
        }
    }
    
    static func quit() {
        NSApplication.shared.terminate(nil)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        AppDelegate.openMainWindow()
        return true
    }
}
