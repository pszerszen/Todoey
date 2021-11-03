//
//  DataHandler.swift
//  Todoey
//
//  Created by Piotr Szerszeń on 14/10/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import ChameleonFramework
import RealmSwift

class DataHandler {
    
    let realm = try! Realm()
    
    private var itemArray: Results<Item>?
    private var categoryArray: Results<Category>?
    
    var itemCount: Int {
        if let itemArray = itemArray {
            return max(itemArray.count, 1)
        }
        return 1
    }

    var categoryCount: Int {
        if let categoryArray = categoryArray {
            return max(categoryArray.count, 1)
        }
        return 1
    }

    // MARK: - Adding

    func addItem(withText title: String, category: Category) {
        do {
            try realm.write {
                let item = Item()
                item.title = title
                item.done = false
                item.dateCreated = Date()
                category.items.append(item)
            }
        } catch {
            print(error)
        }
    }

    func addCategoryWithName(_ name: String) {
        let category = Category()
        category.name = name
        category.colour = UIColor.randomFlat().hexValue()

        do {
            try realm.write { realm.add(category) }
        } catch {
            print(error)
        }
    }

    // MARK: - Getting
    
    func getItem(at index: Int) -> Item? {
        return itemArray?.isEmpty ?? true ? nil : itemArray?[index]
    }

    func getCategory(at index: Int) -> Category? {
        return categoryArray?.isEmpty ?? true ? nil : categoryArray?[index]
    }

    // MARK: - Editing
    
    func toggleItemDone(at index: Int) {
        if let item = getItem(at: index) {
            do {
                try realm.write { item.done = !item.done }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Deleting

    func delete(category: Category) {
        do {
            try realm.write { realm.delete(category) }
        } catch {
            print(error)
        }
    }

    func delete(item: Item) {
        do {
            try realm.write { realm.delete(item) }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Querying
    
    func loadItems(containing query: String = "", forCategory category: Category) {
        itemArray = query == "" ?
                category.items.sorted(byKeyPath: "dateCreated", ascending: true) :
                category.items.filter("title CONTAINS[cd] %@", query)
                            .sorted(byKeyPath: "dateCreated", ascending: true)
    }

    func loadCategoriesData() {
        categoryArray = realm.objects(Category.self).sorted(byKeyPath: "name")
    }
}
