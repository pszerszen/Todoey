//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataHandler.loadItems(forCategory: selectedCategory!)
        tableView.reloadData()

        self.navigationItem.title = "\(selectedCategory!.name) - Items"
    }

    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        if let colorHex = selectedCategory?.colour {
            if let navBarColor = UIColor(hexString: colorHex) {
                //Original setting: navBar.barTintColor = UIColor(hexString: colourHex)
                //Revised for iOS13 w/ Prefer Large Titles setting:
                setNavBarColor(navBarColor)
                searchBar.barTintColor = navBarColor
            }
        }
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHandler.itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = dataHandler.getItem(at: indexPath.row) {
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(
                        byPercentage: CGFloat(indexPath.row) / CGFloat(dataHandler.itemCount)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    // MARK: - TableView Delegete Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataHandler.toggleItemDone(at: indexPath.row)
        tableView.reloadData()
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        super.addButtonPressed(alertTitle: "Add New Todoey Item",
                               actionTitle: "Add Item",
                               placeholder: "Create new item") { [weak self] input in
            guard let self = self else { return }
            self.dataHandler.addItem(withText: input, category: self.selectedCategory!)
        }
    }

    override func updateModel(at index: IndexPath) {
        if let itemToDelete = dataHandler.getItem(at: index.row) {
            dataHandler.delete(item: itemToDelete)
        }
    }
}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            self.dataHandler.loadItems(containing: query, forCategory: self.selectedCategory!)
            self.tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.dataHandler.loadItems(forCategory: self.selectedCategory!)
            self.tableView.reloadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
