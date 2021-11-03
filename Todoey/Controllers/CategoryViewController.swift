//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Piotr Szerszeń on 14/10/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    private let blue: UIColor? = UIColor(hexString: "#1D9BF6")

    override func viewDidLoad() {
        super.viewDidLoad()

        dataHandler.loadCategoriesData()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavBarColor(blue!)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHandler.categoryCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = dataHandler.getCategory(at: indexPath.row) {
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.text = category.name
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        } else {
            cell.textLabel?.text = "No Categories added yet"
        }
        return cell
    }

    // MARK: - Add Button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        super.addButtonPressed(alertTitle: "Add New Category of Items",
                               actionTitle: "Add Category",
                               placeholder: "Create new Category") { [weak self] input in
            self?.dataHandler.addCategoryWithName(input)
        }
    }

    // MARK: - updating model

    override func updateModel(at index: IndexPath) {
        if let categoryToDelete = dataHandler.getCategory(at: index.row) {
            dataHandler.delete(category: categoryToDelete)
        }
    }

    // MARK: - TableView Delegete Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = dataHandler.getCategory(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: Constants.shared.GoToItems, sender: category)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.shared.GoToItems {
            let category = sender as! Category
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = category
        }
    }
}
