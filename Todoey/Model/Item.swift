//
//  Item.swift
//  Todoey
//
//  Created by Giulia Boscaro on 13/01/19.
//  Copyright © 2019 Giulia Boscaro. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
