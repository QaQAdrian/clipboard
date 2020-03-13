//
//  NSViewUtils.swift
//  clipboard
//
//  Created by wyy on 2019/12/9.
//  Copyright © 2019 yahaha. All rights reserved.
//

import AppKit
import Foundation

extension NSView {
    static func createFromNib<T: NSView>(_ name: String, in bundle: Bundle = Bundle.main) -> T? {
        var topLevelArray: NSArray?
        bundle.loadNibNamed(name, owner: nil, topLevelObjects: &topLevelArray)
        guard let results = topLevelArray else { return nil }
        let views = Array<Any>(results).filter { $0 is T }
        return views.last as? T
    }
}

extension NSImage {
//    var width: Int? {
//        get {
//            let reps = self.representations
//            if reps.count > 0 {
//                return reps[0].pixelsWide
//            }
//            return nil
//        }
//    }
//
//    var height: Int? {
//        get {
//            let reps = self.representations
//            if reps.count > 0 {
//                return reps[0].pixelsHigh
//            }
//            return nil
//        }
//    }

//    var size: (Int, Int)? {
//        get {
//            let reps = self.representations
//            if reps.count > 0 {
//                let rep = reps[0]
//                return (rep.pixelsWide, rep.pixelsHigh)
//            }
//            return nil
//        }
//    }
}

// class ImageView: NSView {
//    override init(frame frameRect: NSRect) {
//        <#code#>
//    }
//    self = [super initWithFrame:frame];
//    if (self) {
//      self.layer = [[CALayer alloc] init];
//      self.layer.contentsGravity = kCAGravityResizeAspectFill;
//      self.layer.contents = image;
//      self.wantsLayer = YES;
//    }
//    return self;
//    - (id)initWithFrame:(NSRect)frame andImage:(NSImage*)image
//    {
//
//    }
// }

class OSXUtils {
    static func isDarkMode() -> Bool {
        if #available(OSX 10.14, *) {
            let apperance = NSApp.effectiveAppearance
            let res = apperance.bestMatch(from:[NSAppearance.Name.darkAqua, NSAppearance.Name.aqua])
            return res == NSAppearance.Name.darkAqua
        }
        return false
    }
}
