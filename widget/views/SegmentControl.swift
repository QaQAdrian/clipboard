//
//  SegmentControl.swift
//  widget
//
//  Created by wyy on 2019/12/6.
//  Copyright © 2019 yahaha. All rights reserved.
//

import AppKit
import Foundation

class SegmentedControlCell: NSSegmentedCell {
    override func drawSegment(_ segment: Int, inFrame frame: NSRect, with controlView: NSView) {
        var color: NSColor
        if selectedSegment == segment {
            color = NSColor.red
        } else {
            color = NSColor.white
        }
        color.setFill()
        frame.fill()
        super.drawSegment(segment, inFrame: frame, with: controlView)
    }
}
