//
//  ShoppingModel.swift
//  DiDe
//
//  Created by Deepak SK on 2/07/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Shopping {
    
    let key: String
    let name: String
    var completed: Bool
    let addedByUser: String
    let itemRef: FIRDatabaseReference?
    
    init(name: String, completed: Bool, addedByUser: String, key: String = "") {
        self.name = name
        self.completed = completed
        self.addedByUser = addedByUser
        self.key = key
        self.itemRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        self.key = snapshot.key
        self.itemRef = snapshot.ref
        
        if let name = snapshot.value!["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let completed = snapshot.value!["completed"] as? Bool {
            self.completed = completed
        } else {
            self.completed = false
        }
        
        if let addedByUser = snapshot.value!["addedByUser"] as? String {
            self.addedByUser = addedByUser
        } else {
            self.addedByUser = ""
        }
        
    }
    
    func toAnyObject() -> AnyObject {
        return ["name": name, "completed": completed, "addedByUser": addedByUser]
    }
}
