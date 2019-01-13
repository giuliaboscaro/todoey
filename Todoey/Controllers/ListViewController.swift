//
//  ViewController.swift
//  Todoey
//
//  Created by Giulia Boscaro on 31/12/18.
//  Copyright © 2018 Giulia Boscaro. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController{

    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
        searchBar.delegate = self
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.name
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK - Add new items functionality
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
    
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        if let itemName = textField.text {
                            newItem.name = itemName
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                } catch {
                    print("Error saving data \(error)")
                }
            }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "That thing you need to do"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension ListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        toDoItems = toDoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
        tableView.reloadData()
    }

}
