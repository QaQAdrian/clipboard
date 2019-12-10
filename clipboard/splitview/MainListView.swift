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
    private var items: ClipboardItems = []
    @IBOutlet var pinBtn: NSButton! {
        didSet {
            checkPinBtn()
        }
    }
    
    private var pinned = true {
        didSet {
            checkPinBtn()
        }
    }
    
    func checkPinBtn() {
        if pinBtn != nil {
            pinBtn.image = self.pinned ? NSImage(named: "pin") : NSImage(named: "unpin")
            self.view.window?.level = self.pinned ? .floating: .normal;
        }
    }
    
    @IBAction func pin(_ sender: Any) {
        self.pinned = !self.pinned
    }

    @IBAction func expandRightView(_ sender: NSButton) {
        if let existParent = splitViewController() {
            existParent.expand()
        }
    }

    @IBAction func clearUp(_ sender: Any) {
        self.items.removeAll()
        tableView.reloadData()
    }
    func splitViewController() -> SplitViewController? {
        if let existParent = self.parent, existParent is SplitViewController {
            return existParent as? SplitViewController
        }
        return nil
    }

    private let clipboard = ClipboardListener.shared;
}

extension MainListViewController: NSTableViewDelegate, NSTableViewDataSource {
    override func viewDidLoad() {
        checkPinBtn()
        let constraints = [
            self.view.widthAnchor.constraint(equalToConstant: 320),
        ]
        NSLayoutConstraint.activate(constraints)
        tableView.delegate = self
        tableView.dataSource = self
        clipboard.onNewCopy {
            if self.items.appendExcludeSame($0) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: {_ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
        if let selected = item {
            selected.copy()
            view.showCheckMark()
        }
    }

    func getPreviewController() -> PreviewController? {
        if let controller = splitViewController() {
            if let preview = controller.children.last, preview is PreviewController {
                return preview as? PreviewController
            }
        }
        return nil
    }

    // 点击预览
    private func preview(_ item: ClipboardOSX?) {
        splitViewController()?.expandRightView()
        getPreviewController()?.item = item
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
        view.click = clickHook
        view.preview = preview
        view.itemId = item.id
        view.item = item
        view.setImage(image: item.showImage())
        view.setText(content: item.content)
        view.setElapse(createDate: item.createDate)
        return view
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count 
    }
}
