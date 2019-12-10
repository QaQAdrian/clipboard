//
//  NSViewUtils.swift
//  clipboard
//
//  Created by wyy on 2019/12/9.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation
import AppKit

extension NSView {
    static func createFromNib<T: NSView>(_ name: String, in bundle: Bundle = Bundle.main) -> T? {
        var topLevelArray: NSArray? = nil
        bundle.loadNibNamed(name, owner: nil, topLevelObjects: &topLevelArray)
        guard let results = topLevelArray else { return nil }
        let views = Array<Any>(results).filter { $0 is T }
        return views.last as? T
    }
}
