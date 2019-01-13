//
//  Category.swift
//  Todoey
//
//  Created by Giulia Boscaro on 13/01/19.
//  Copyright © 2019 Giulia Boscaro. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
