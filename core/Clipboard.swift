//
//  Clipboard.swift
//  clipboard
//
//  Created by wyy on 2019/12/2.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation

class Clipboard {
    var id: String
    var type: CType
    var createDate: Date
    var content: String?
    var contentWithFormat: String?
    var url: URL?

    init(type: CType, createDate: Date, url: URL?) {
        self.id = UUID().uuidString
        self.type = type
        self.createDate = createDate
        self.url = url
    }

    init(content: String, type: CType, url: URL?) {
        self.id = UUID().uuidString
        self.content = content
        self.type = type
        self.url = url
        self.createDate = Date()
    }

    init(content: String, type: CType) {
        self.id = UUID().uuidString
        self.content = content
        self.type = type
        self.createDate = Date()
    }

    init(content: String, contentWithFormat: String?, type: CType) {
        self.id = UUID().uuidString
        self.content = content
        self.contentWithFormat = contentWithFormat
        self.type = type
        self.createDate = Date()
    }
}

extension Clipboard {
    enum CType {
        case STR
        case IMAGE
        case FILE
        case HTML
        case URL
    }
}