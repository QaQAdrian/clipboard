//
//  MainListView.swift
//  clipboard
//
//  Created by wyy on 2019/12/9.
//  Copyright © 2019 yahaha. All rights reserved.
//

import AppKit
import Foundation

class MainListViewController: NSViewController {
    @IBOutlet var tableView: NSTableView!
//    private var textItem: ListTextItem?

    private var items: [ClipboardOSX]?

    private var clipboardListener = ClipboardListener.shared {
        didSet {
            clipboardListener.onNewCopy({
                self.items?.append($0)
                self.tableView.reloadData()
            })
        }
    }
}

extension MainListViewController: NSTableViewDelegate, NSTableViewDataSource {
    override func viewDidLoad() {
        let constraints = [
            self.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
        ]
        NSLayoutConstraint.activate(constraints)

//        textItem = ListTextItem.createFromNib("ListTextItemView")
        tableView.delegate = self
        tableView.dataSource = self
        self.items = [
            ClipboardOSX(content: "yahahha1"),
            ClipboardOSX(content: "yahahha2"),
            ClipboardOSX(content: "yahahha3yahahha3yahahha3yahahha3yahahha3yahahha3yahahha3yahahha3"),
            ClipboardOSX(content: "yahahha4"),
            ClipboardOSX(content: "yahahha5"),
            ClipboardOSX(content: "yahahha6yahahha6yahahha6yahahha6yahahha6yahahha6yahahha6"),
        ]
        tableView.reloadData()
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let view = loadListTextItemView()
        return view?.frame.height ?? 70
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
        print("click preview")
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
        guard tableColumn != nil,
            let item = items?[row],
            let view = loadListTextItemView() else {
            return nil
        }
        view.click = clickHook
        view.preview = preview
        view.itemId = item.id
        view.item = item
        view.setImage(image: NSImage(named: "TypeIcon"))
        view.setText(content: item.content)
        view.setElapse(createDate: item.createDate)
        return view
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items?.count ?? 0
    }
}
