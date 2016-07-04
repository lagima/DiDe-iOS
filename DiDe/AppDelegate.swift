//
//  AppDelegate.swift
//  DiDe
//
//  Created by Deepak SK on 26/06/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentUser:User!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Connect to Firebase
        FIRApp.configure()
        
        self.prepareApp();
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Untrack any tracked users
        if var previouslyTracked = LocationManager.sharedInstance.trackedPerson {
            previouslyTracked.tracking -= 1
            previouslyTracked.updateTracking()
            
            LocationManager.sharedInstance.trackedPerson = nil
        }
    }

    
    // MARK: Custom methods
    
    private func prepareApp() {
        
        // Force logout
        // try! FIRAuth.auth()!.signOut()
        
        // Get the views from storyboard to navigate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        
        // Check if logged in
        FIRAuth.auth()?.addStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            
            if let user = user {
                
                let dbRef = FIRDatabase.database().reference().child("user")
                // User is signed in get data
                dbRef.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    self.currentUser = User(snapshot: snapshot)
                    
                    self.startObservingDB()
                    
                    self.window?.rootViewController = tabBarController
                   
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            else {
                // No user is signed in.
                self.window?.rootViewController = loginViewController
            }
        })
        
    }
    
    // MARK: DB Observers
    
    func startObservingDB() {
        
        let dbRef:FIRDatabaseReference = FIRDatabase.database().reference().child("user")
        
        dbRef.observe(.value, with: { (snapshot) in
            
            for snapshotItem in snapshot.children {
                let user = User(snapshot: snapshotItem as! FIRDataSnapshot)
                
                // If current user is in snapshot
                if(user.email != self.currentUser.email) {
                    continue
                }
                
                // If the user is current user update em
                self.currentUser = user
                
                if(user.tracking > 0) {
                    print("Tracking: \(user.email)")
                    LocationManager.sharedInstance.currentUser = user
                    LocationManager.sharedInstance.startTracking();
                } else {
                    LocationManager.sharedInstance.stopTracking();
                }
            }

        }) { (error) in
            // error handling
        }
    }

}

