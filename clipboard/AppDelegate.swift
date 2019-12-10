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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        clipboard.startListening()
        NSApp.setActivationPolicy(.regular)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("will terminate")
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        print("resign active")
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        print("receive \(urls)")
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        sender.activate(ignoringOtherApps: true)
        if !flag {
            print(sender.windows.count)
            for window: AnyObject in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }
}
