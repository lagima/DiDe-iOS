//
//  ShoppingViewController.swift
//  DiDe
//
//  Created by Deepak SK on 27/06/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ShoppingTableViewController: UITableViewController {

    let cellIdentifier: String = "shoppingItemCell"
    var dbRef:FIRDatabaseReference!
    var shoppingItems = [Shopping]()
    
    @IBOutlet var shoppingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shoppingTableView.separatorInset = UIEdgeInsetsZero
        self.shoppingTableView.layoutMargins = UIEdgeInsetsZero
        
        // Do any additional setup after loading the view.
        dbRef = FIRDatabase.database().reference().child("shoppingitem")
        
        // Start observing data
        self.startObservingDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Parse datasourcce methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let shoppingItem = shoppingItems[indexPath.row]
        cell.textLabel?.text = shoppingItem.name
        
        if(shoppingItem.completed) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: AnyObject?) -> UITableViewCell? {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        if let pfObject = object {
            
            // Set the completed
            if let completed = pfObject["completed"] as? Bool {
                // Show/Hide checkmark
                if(completed) {
                    cell?.accessoryType = .checkmark
                } else {
                    cell?.accessoryType = .none
                }
            }
            
            // Set the name
            if let name = pfObject["name"] as? String {
                cell?.textLabel?.text = name
            }
            else {
                cell?.textLabel?.text = "No Name"
            }
        }
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var shoppingItem = shoppingItems[indexPath.row]
        shoppingItem.completed = !shoppingItem.completed
        
        shoppingItem.itemRef?.setValue(shoppingItem.toAnyObject())
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let shoppingItem = shoppingItems[indexPath.row]
        
        if editingStyle == .delete {
            shoppingItem.itemRef?.removeValue()
        }
    }
    
    @IBAction func addShoppingItem(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "New Item", message: "Do you really need this ?", preferredStyle: .alert)
        
        // Make confirm action
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            if let name = alertController.textFields![0].text {
                // store your data
                let shoppingItem = Shopping(name: name, completed: false, addedByUser: "Deepak")
                let shoppingRef = self.dbRef.child(name.lowercased())
                shoppingRef.setValue(shoppingItem.toAnyObject())
            } else {
                // user did not fill field
            }
        }
        
        // Make cancel action
        let cancelAction = UIAlertAction(title: "No Need", style: .cancel) { (_) in }
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Shopping item"
        })
        
        // Add the action to alert
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // Present it
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: DB Observers
    
    func startObservingDB() {
        dbRef.observe(.value, with: { (snapshot) in
            
            var newShoppingItems = [Shopping]()
            
            for snapshotItem in snapshot.children {
                let shoppingItem = Shopping(snapshot: snapshotItem as! FIRDataSnapshot)
                newShoppingItems.append(shoppingItem)
            }
            
            self.shoppingItems = newShoppingItems
            self.tableView.reloadData()
            
        }) { (error) in
            
        }
    }


}
