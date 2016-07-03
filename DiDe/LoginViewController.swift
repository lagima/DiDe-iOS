//
//  LoginViewController.swift
//  DiDe
//
//  Created by Deepak SK on 26/06/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        let appDeligate = UIApplication.shared().delegate as! AppDelegate
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        FIRAuth.auth()?.signIn(withEmail: username, password: password) { user, error in
            print(user)
            if error != nil {
                // an error occured while attempting login
                print(error)
            } else {
                // user is logged in, check authData for data
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                
                appDeligate.window?.rootViewController = tabBarController
            }
        }
    }
    

}
