//
//  GrideTable.swift
//  clipboard
//
//  Created by wyy on 2019/12/9.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

// 事件响应
class GridTable: NSTableView {
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
        true
    }
}
