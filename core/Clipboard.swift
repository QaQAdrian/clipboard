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
    var showType: ShowType {
        get {
            switch self.type {
            case .STR,.HTML: return .STR
            case .IMAGE: return .IMAGE
            case .FILE,.URL: return .FILE
            }
        }
    }
    var createDate: Date
    var content: String?
    var contentWithFormat: String?
    var url: URL?
    var imageWidth: Int?
    var imageHeight: Int?
    var data: Data?

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
    
    
    
    func isSameContent(_ other: Clipboard) -> Bool {
        if self.showType != other.showType {
            return false
        }
        if self.content != nil && self.content == other.content {
            return true
        }
        if self.url != nil && self.url == other.url {
            return true
        }
        if self.data != nil && self.data == other.data {
            return true
        }
        return false
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
    
    enum ShowType {
        case STR
        case IMAGE
        case FILE
    }
}
