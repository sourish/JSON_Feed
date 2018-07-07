//
//  Item.swift
//  JSON_Feed
//
//  Created by Sourish on 07/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import UIKit

class Item {
    var descriptionField = ""
    var imageHref = ""
    var title = ""
    var feedImage: UIImage?
    
    let kRowDescriptionField = "description"
    let kRowImageHref = "imageHref"
    let kRowTitle = "title"
    
    init(dictionary: [AnyHashable : Any]) {
        if !(dictionary[kRowDescriptionField] is NSNull) {
            descriptionField = dictionary[kRowDescriptionField] as! String
        }
        if !(dictionary[kRowImageHref] is NSNull) {
            imageHref = dictionary[kRowImageHref] as! String
        }
        if !(dictionary[kRowTitle] is NSNull) {
            title = dictionary[kRowTitle] as! String
        }
    }
    
    convenience init() {
        self.init(dictionary: [:])
    }
}
