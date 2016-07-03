//
//  SignupViewController.swift
//  DiDe
//
//  Created by Deepak SK on 27/06/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignupViewController: UIViewController {
    
    var dbRef:FIRDatabaseReference!
    
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbRef = FIRDatabase.database().reference().child("user")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: AnyObject) {
        
        let appDeligate = UIApplication.shared().delegate as! AppDelegate
        
        let email = emailField.text!
        let password = passwordField.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { user, error in
            
            if error != nil {
                // Show the errorString somewhere and let the user try again.
                print(error?.description)
            } else {
                
                // Make user data to manage family relationship
                let userLocal = User(email:(user?.email)!, displayName: self.displayNameField.text!)
                let userRef = self.dbRef.child(user!.uid)
                userRef.setValue(userLocal.toAnyObject())
                
                // Hooray! Let them use the app now.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                
                appDeligate.window?.rootViewController = tabBarController
            }
            
        });
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
