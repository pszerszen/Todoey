//
//  Category.swift
//  Todoey
//
//  Created by Piotr Szerszeń on 15/10/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""

    let items = List<Item>()
}
