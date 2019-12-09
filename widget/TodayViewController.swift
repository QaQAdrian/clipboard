//
//  TodayViewController.swift
//  widget
//
//  Created by wyy on 2019/12/4.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
    @IBOutlet var segmentControl: NSSegmentedControl!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var scrollView: NSScrollView!

    private var clipboardListener = ClipboardListener.shared {
        didSet {
            clipboardListener.onNewCopy({
                self.items.append($0)
                self.tableView.reloadData()
            })
        }
    }

    private lazy var items = [
        ClipboardOSX(content: "yahahha1"),
        ClipboardOSX(content: "yahahha2"),
        ClipboardOSX(content: "yahahha3yahahha3yahahha3yahahha3yahahha3yahahha3yahahha3yahahha3"),
        ClipboardOSX(content: "yahahha4"),
        ClipboardOSX(content: "yahahha5"),
        ClipboardOSX(content: "yahahha6yahahha6yahahha6yahahha6yahahha6yahahha6yahahha6"),
    ]

    override var nibName: NSNib.Name? {
        NSNib.Name("TodayViewController")
    }

    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.newData)
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension TodayViewController: NSTableViewDelegate, NSTableViewDataSource {
    override func viewDidLoad() {
        segmentControl.segmentDistribution = .fillEqually
        let width = view.frame.size.width / 2 - 20
        segmentControl.setWidth(width, forSegment: 0)
        segmentControl.setWidth(width, forSegment: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        false
    }

    public func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        false
    }

    // 点击cell
    private func clickHook(_ item: ClipboardOSX?, _ view: ListTextItem) {
        if let selected = item, let str = selected.content {
            clipboardListener.copy(str)
            view.showCheckMark()
        }
    }

    // 点击预览
    private func preview(_ item: ClipboardOSX?) {
        NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.blabla.clipboard", options: [NSWorkspace.LaunchOptions.async], additionalEventParamDescriptor: NSAppleEventDescriptor(string: "Hello"), launchIdentifier: nil)
//        if let url = URL(string: "clipboard://abc") {
//            self.extensionContext?.open(url, completionHandler: {print("open main app \($0)")})
//        }
    }

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard tableColumn != nil else {
            return nil
        }
        let itemView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ListTextItem"), owner: tableColumn) as! ListTextItem
        let item = items[row]
        itemView.click = clickHook
        itemView.preview = preview
        itemView.itemId = item.id
        itemView.item = item
        itemView.setImage(image: NSImage(named: "TypeIcon"))
        itemView.setText(content: item.content)
        itemView.setElapse(createDate: item.createDate)
        return itemView
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        items.count
    }
}
