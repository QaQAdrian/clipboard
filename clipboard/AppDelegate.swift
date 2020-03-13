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

    @IBOutlet var menu: Menu!

    var item: NSStatusItem?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        clipboard.startListening()
//        iStatucBar = StatusBar(menu)
//        let flag = OSXUtils.isDarkMode()
        if let image = NSImage(named: "clipboard") {
            item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            image.size = NSMakeSize(18.0, 18.0)
            item?.image = image
            item?.highlightMode = true
            item?.image?.isTemplate = true
            item?.button?.target = self
            item?.button?.action = #selector(buttonAction(sender:))
//            item?.button?.performClick(#selector(buttonAction))
        }
        NSApp.setActivationPolicy(.regular)
    }

    @objc func buttonAction(sender: Any!) {
        AppDelegate.openMainWindow()
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

    func applicationWillTerminate(_ notification: Notification) {
        AppDelegate.clearCache()
    }

    static func clearCache() {
        let cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        let files = FileManager.default.subpaths(atPath: cachPath as String)
        for p in files! {
            let path = cachPath.appendingPathComponent(p)
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }
}
