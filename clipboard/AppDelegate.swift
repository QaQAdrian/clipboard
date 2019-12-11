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

    @IBOutlet weak var menu: Menu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        clipboard.startListening()
        iStatucBar = StatusBar(menu)
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
