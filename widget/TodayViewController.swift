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
    
//    override func viewDidAppear() {
//        print("did appear")
//        print(self.view.frame)
//        print(self.view.bounds)
//        print(self.view.superview?.frame)
//        print("did appear")
//        self.view.sizetoFit
//    }
}

extension TodayViewController: NSTableViewDelegate, NSTableViewDataSource {
    override func viewDidLoad() {
        self.view.frame = NSRect(x: 0, y: 0, width: 312, height: 330)
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

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard tableColumn != nil else {
            return nil
        }
        print("reload")
        let itemView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ListTextItem"), owner: tableColumn) as! ListTextItem
        let item = items[row]
        itemView.setImage(image: NSImage(named: "TypeIcon"))
        itemView.setText(content: item.content)
        itemView.setElapse(createDate: item.createDate)
        return itemView
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        items.count
    }

    // MARK: button event

    // TODO: thread safe
    @objc private func removeItem(btn: RemoveBtn) {
        items.removeAll(where: {
            if let itemId = btn.itemId {
                return $0.id == itemId
            }
            return false
        })
        tableView.reloadData()
    }

    @objc private func pasteItem(btn: PasteBtn) {
        let item = items.first(where: {
            if let itemId = btn.itemId {
                return $0.id == itemId
            }
            return false
        })
        if let found = item, let str = found.content {
            clipboardListener.copy(str)
        }
    }
}
