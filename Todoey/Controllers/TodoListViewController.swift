//
//  ViewController.swift
//  Todoey
//
//  Created by Bui Anh on 4/9/19.
//  Copyright © 2019 Bui Anh. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  var itemArray = [Item]()
  
  // let defaults = UserDefaults.standard
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   
//    let newItem = Item()
//    newItem.title = "Find Mike"
//
//    itemArray.append(newItem)
//
//    let newItem1 = Item()
//    newItem1.title = "Find Mike1"
//    itemArray.append(newItem1)
//
//    let newItem2 = Item()
//    newItem2.title = "Find Mike1"
//    itemArray.append(newItem2)
//
//    let newItem3 = Item()
//    newItem3.title = "Find Mike"
//    itemArray.append(newItem3)
    
    //    if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
    //      itemArray = items
    //    }
    loadItems()
    
  }
  
  //MARK - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // create new cell
    //  let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
    // reuse cell
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    
    // Ternary operatior ==>
    // value = condition ? valueIfTrue : valueIfFalse
    cell.accessoryType = item.done == true ? .checkmark : .none
    
    return cell
  }
  
  //MARK - TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItem()
    
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  //Mark - Add New Items
  
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button on our UIAlert
      let newItem = Item()
      newItem.title = textField.text!
      
      self.itemArray.append(newItem)
      
      self.saveItem()
     
      // self.defaults.set(self.itemArray, forKey: "TodoListArray")
     // self.tableView.reloadData()
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  // MARK - Model manupulation methods
  
  func saveItem(){
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
      
    } catch {
      print("Error encoding item array, \(error)")
      
    }
    self.tableView.reloadData()
    
  }
  
  func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!){
      let decoder = PropertyListDecoder()
      do {
        itemArray = try decoder.decode([Item].self, from: data)
    } catch {
      print("Error decoding item array, \(error)")
    }
  }
  }
  
  
}

