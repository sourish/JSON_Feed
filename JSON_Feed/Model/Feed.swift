//
//  Feed.swift
//  JSON_Feed
//
//  Created by Sourish on 07/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import Foundation

class Feed {
    var rows: [Item] = []
    var title = ""
    
    let kRootClassRows = "rows"
    let kRootClassTitle = "title"
    
    init(dictionary: [AnyHashable : Any]) {
        if dictionary[kRootClassRows] != nil && (dictionary[kRootClassRows] is [Any]) {
            let rowsDictionaries = dictionary[kRootClassRows] as? [Any]
            var rowsItems: [Item] = []
            for rowsDictionary in rowsDictionaries! {
                let rowsItem: Item? = Item(dictionary: rowsDictionary as! [AnyHashable : Any])
                rowsItems.append(rowsItem!)
            }
            rows = rowsItems
        }
        if !(dictionary[kRootClassTitle] is NSNull) {
            title = dictionary[kRootClassTitle] as! String
        }
    }
    convenience init() {
        self.init(dictionary: [:])
    }
}
