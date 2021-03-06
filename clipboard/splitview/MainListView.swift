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
    @IBOutlet var scrollList: NSScrollView!
    private var items: ClipboardItems = [] {
        didSet {
            let isEmpty = items.count <= 0
            DispatchQueue.main.async {
                self.emptyView?.isHidden = !isEmpty
                self.scrollList?.isHidden = isEmpty
                if !isEmpty {
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBOutlet var pinBtn: NSButton!
    @IBOutlet var emptyView: NSView!
    @IBOutlet var noticeView: Notice!
    
    private var splitController: SplitViewController?
    private var selected: String?

    private var pinned = UserDefaults.standard.bool(forKey: "pinned") {
        didSet {
            checkPinBtn()
            UserDefaults.standard.set(pinned, forKey: "pinned")
        }
    }

    func checkPinBtn() {
        if pinBtn != nil {
            pinBtn.image = pinned ? NSImage(named: "pin") : NSImage(named: "unpin")
        }
        view.window?.level = pinned ? .floating : .normal
    }

    @IBAction func pin(_ sender: Any) {
        pinned = !pinned
    }

    @IBAction func clearUp(_ sender: Any) {
        items.removeAll()
        AppDelegate.clearCache()
    }

    private let clipboard = ClipboardListener.shared
}

extension MainListViewController: NSTableViewDelegate, NSTableViewDataSource {
    override func viewDidLoad() {
//        checkPinBtn() 这里没用
        let constraints = [
            self.view.widthAnchor.constraint(equalToConstant: 320),
        ]
        NSLayoutConstraint.activate(constraints)
        tableView.delegate = self
        tableView.dataSource = self
        splitController = splitViewController()
        clipboard.onNewCopy {
            _ = self.items.appendExcludeSame($0)
        }
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        tableView.reloadData()
    }

    override func viewDidAppear() {
        checkPinBtn()
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let view = loadListTextItemView()
        view?.tableView = self.tableView
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
            items.count > row,
            let view = loadListTextItemView() else {
            return nil
        }
        let item = items[row]
        view.click = { (_ item: ClipboardOSX?, _: ListTextItem) -> Void in
            if let curSelected = item {
                self.selected = curSelected.id
                curSelected.copy()
                self.noticeView.start()
            }
        }
        view.itemId = item.id
        view.item = item
        view.storyboard = storyboard
        view.setImage(image: item.showImage())
        view.setText(content: item.showContent())
        view.setElapse(createDate: item.createDate)
        return view
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
}

extension MainListViewController {
    func splitViewController() -> SplitViewController? {
        if let existParent = self.parent, existParent is SplitViewController {
            return existParent as? SplitViewController
        }
        return nil
    }
}
