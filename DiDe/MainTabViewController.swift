//
//  MainTabViewController.swift
//  DiDe
//
//  Created by Deepak SK on 4/07/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if(item.tag != 2) {
            // Untrack any tracked users
            if var previouslyTracked = LocationManager.sharedInstance.trackedPerson {
                previouslyTracked.tracking -= 1
                previouslyTracked.updateTracking()
                
                LocationManager.sharedInstance.trackedPerson = nil
            }
        }
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
