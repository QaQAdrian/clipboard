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

    private var clipboardListener = ClipboardListener.shared {
        didSet {
            self.clipboardListener.onNewCopy({
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
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.newData)
    }
}

extension TodayViewController: NSTableViewDelegate, NSTableViewDataSource {
    override func viewDidLoad() {
        segmentControl.segmentDistribution = .fillEqually
        let width = self.view.frame.size.width / 2 - 20
        segmentControl.setWidth(width, forSegment: 0)
        segmentControl.setWidth(width, forSegment: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.reloadData()
    }

    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        false
    }

    public func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        false
    }

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let columnView = tableColumn else {
            return nil
        }

        let image = NSImage(named: "TypeIcon")
        let item = items[row]
        var view: NSView?
        switch tableColumn?.identifier.rawValue {
        case "iconColumn": view = getImageCellView(tableView: tableView, columnView: columnView, image: image)
        case "labelColumn": view = getTextCellView(tableView: tableView, columnView: columnView, content: item.content ?? "")
        case "copyColumn": view = getPasteBtn(tableView: tableView, columnView: columnView, id: item.id)
        case "removeColumn": view = getRemoveBtn(tableView: tableView, columnView: columnView, id: item.id)
        default: break
        }
        return view
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

    func getTextCellView(tableView: NSTableView, columnView: NSTableColumn, content: String) -> NSTextField? {
        var cellView = tableView.makeView(withIdentifier: columnView.identifier, owner: tableView) as? NSTextField
        if cellView == nil {
            cellView = NSTextField()
            cellView?.isEditable = false
            cellView?.isBezeled = false
            cellView?.drawsBackground = false
            cellView?.isSelectable = false
            cellView?.usesSingleLineMode = false
            cellView?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
            cellView?.identifier = columnView.identifier
            cellView?.maximumNumberOfLines = 2
            cellView?.font = NSFont.systemFont(ofSize: 14)
            cellView?.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        }
        cellView?.stringValue = content
        return cellView
    }

    func getImageCellView(tableView: NSTableView, columnView: NSTableColumn, image: NSImage?) -> NSView? {
        var cellView = tableView.makeView(withIdentifier: columnView.identifier, owner: tableView) as? NSImageView
        if cellView == nil {
            cellView = NSImageView()
            cellView?.identifier = columnView.identifier
        }
        cellView?.image = image
        return cellView
    }

    func getRemoveBtn(tableView: NSTableView, columnView: NSTableColumn, id: String) -> RemoveBtn? {
        var cellView = tableView.makeView(withIdentifier: columnView.identifier, owner: tableView) as? RemoveBtn
        if cellView == nil {
            cellView = RemoveBtn(frame: NSRect(x: 0, y: 0, width: 15, height: 15))
            cellView?.action = #selector(removeItem)
            cellView?.target = self
            cellView?.identifier = columnView.identifier
        }
        cellView?.itemId = id
        return cellView
    }

    func getPasteBtn(tableView: NSTableView, columnView: NSTableColumn, id: String) -> PasteBtn? {
        var cellView = tableView.makeView(withIdentifier: columnView.identifier, owner: tableView) as? PasteBtn
        if cellView == nil {
            cellView = PasteBtn(frame: NSRect(x: 0, y: 0, width: 15, height: 15))
            cellView?.action = #selector(pasteItem)
            cellView?.target = self
            cellView?.identifier = columnView.identifier
        }
        cellView?.itemId = id
        return cellView
    }
}
