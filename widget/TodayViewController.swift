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

    private lazy var items:ClipboardItems = []

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
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: {_ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        ClipboardListener.shared.onNewCopy({
            if self.items.appendExcludeSame($0) {
                if self.items.count > 5 {
                    self.items.removeSubrange(5...self.items.count - 1)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        ClipboardListener.shared.startListening()
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
        if let selected = item {
            selected.copy()
            view.showCheckMark()
        }
    }

    // 点击预览
    private func preview(_ item: ClipboardOSX?) {
        NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.blabla.clipboard", options: [NSWorkspace.LaunchOptions.async], additionalEventParamDescriptor: NSAppleEventDescriptor(string: "Hello"), launchIdentifier: nil)
    }
    
    private func loadListTextItemView() -> ListTextItem? {
        var itemView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ListTextItem"), owner: self) as? ListTextItem
        if itemView == nil {
            itemView = ListTextItem.createFromNib("ListTextItemView")
            itemView?.identifier = NSUserInterfaceItemIdentifier(rawValue: "ListTextItem")
        }
        return itemView
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
        itemView.setImage(image: item.showImage())
        itemView.setText(content: item.content)
        itemView.setElapse(createDate: item.createDate)
        return itemView
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        items.count
    }
}
