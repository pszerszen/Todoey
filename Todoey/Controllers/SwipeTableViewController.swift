//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Piotr Szerszeń on 17/10/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit
import CloudKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    let dataHandler = DataHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    func setNavBarColor(_ color: UIColor) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        let contrast = ContrastColorOf(color, returnFlat: true)

        // sets the right (Add button color)
        navigationController?.setThemeUsingPrimaryColor(color, with: .contrast)
        // sets the back button color
        navBar.tintColor = contrast

        navBar.backgroundColor = color
        navBar.tintColor = contrast
        navBar.barTintColor = color

        navBar.scrollEdgeAppearance?.backgroundColor = color
        navBar.scrollEdgeAppearance?.shadowColor = color
        navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrast]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            self?.updateModel(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive

        return options
    }

    func addButtonPressed(alertTitle: String, actionTitle: String, placeholder: String, addModel: @escaping (String) -> Void) {
        var textField = UITextField()

        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] alert in
            guard let self = self else { return }
            if textField.hasText {
                addModel(textField.text!)
                self.tableView.reloadData()
            }
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = placeholder
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func updateModel(at index: IndexPath) {}

}
