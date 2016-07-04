//
//  FriendsTableViewController.swift
//  DiDe
//
//  Created by Deepak SK on 30/06/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FamilyTableViewController: UITableViewController {
    
    let cellIdentifier: String = "familyCell"
    let locationManager = LocationManager.sharedInstance
    var dbRef:FIRDatabaseReference!
    var familyMembers = [User]()
    var currentUser:User!
    
    var previouslyTracked:User!
    var currentlyTracked:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        let appDeligate = UIApplication.shared().delegate as! AppDelegate
        self.currentUser = appDeligate.currentUser
        
        // Do any additional setup after loading the view.
        dbRef = FIRDatabase.database().reference().child("user")
        
        // Start observing 
        self.startObservingDB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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
    
    // MARK: Datasourcce methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyMembers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let familyMember = familyMembers[indexPath.row]
        cell.textLabel?.text = familyMember.displayName
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "LocationNavigationController") as! UINavigationController
        //let destination = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        var familyMember = familyMembers[indexPath.row]
        
        
        // If previously tracked == currently tracked do nothing
        if(self.previouslyTracked != nil && familyMember.email == self.previouslyTracked.email) {
            // Close the sidebar
            revealViewController().revealToggle(animated: true);
        }
        else {
            
            // Save the tracked user in placeholder
            LocationManager.sharedInstance.trackedPerson = familyMember
            
            // Stop tracking previously tracked
            if(self.previouslyTracked != nil) {
                self.previouslyTracked.tracking -= 1
                self.previouslyTracked.updateTracking()
            }
            
            // Start tracking new
            familyMember.tracking += 1
            familyMember.updateTracking()
            
            // Update who we are tracking
            self.currentUser?.trackedUser = familyMember.email
            self.currentUser?.updateTrackedUser()
            
            // Set this currently tracked on previous for next cycle
            self.previouslyTracked = familyMember
            
            // Close the sidebar and show map
            revealViewController().revealToggle(animated: true);
            revealViewController().setFront(navController, animated:false)
        }
    }
    
    // MARK: DB Observers
    
    func startObservingDB() {
       
        dbRef.observe(.value, with: { (snapshot) in
            
            var newMembers = [User]()
            
            for snapshotItem in snapshot.children {
                let user = User(snapshot: snapshotItem as! FIRDataSnapshot)
                newMembers.append(user)
                
                // Update the user
                if(LocationManager.sharedInstance.trackedPerson != nil && user.email == LocationManager.sharedInstance.trackedPerson?.email) {
                    LocationManager.sharedInstance.trackedPerson = user
                }
            }
            
            self.familyMembers = newMembers
            self.tableView.reloadData()
            
        }) { (error) in
            // error handling
            print(error.description)
        }
    }
}
