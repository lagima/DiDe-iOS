//
//  LocationViewController.swift
//  DiDe
//
//  Created by Deepak SK on 29/06/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = LocationManager.sharedInstance
    var currentUser:User!
    var familyPins = [FamilyAnnotation]()
    
    
    let dbRef = FIRDatabase.database().reference().child("user")
    var refHandle: FIRDatabaseHandle!
    
    @IBOutlet weak var locateMapView: MKMapView!
    @IBOutlet weak var openSideBar: UIBarButtonItem!
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDeligate = UIApplication.shared().delegate as! AppDelegate
        self.currentUser = appDeligate.currentUser
        
        openSideBar.target = self.revealViewController()
        openSideBar.action = #selector(SWRevealViewController.revealToggle(_:))
    
        // Map related code
        self.locateMapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set the title
        if let trackedPerson = LocationManager.sharedInstance.trackedPerson {
            titleNavigationItem.title = "Tracking " + (trackedPerson.displayName)
            
            // Start observing
            self.startObservingDB()
        }
        else {
            titleNavigationItem.title = "Tracking You"
            
            // Remove all annotations
            self.locateMapView.removeAnnotations(familyPins)
            familyPins.removeAll()
            
            // Set self tracking
            let latitude = self.locateMapView.userLocation.coordinate.latitude
            let longitude = self.locateMapView.userLocation.coordinate.longitude
            setLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let refHandle = self.refHandle {
            dbRef.removeObserver(withHandle: refHandle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Map Tracking

   
    func setLocation(latitude: Double, longitude: Double) {
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let zoomin = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        // let zoomout = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        // self.locateMapView.setRegion(zoomout, animated: true)
        self.locateMapView.setRegion(zoomin, animated: true)
    }
    
    func markLocation(latitude: Double, longitude: Double) {
        
        /**
         * If found move/update the marker and update the user location
         * Rule:
         * 1. If found the anotation already just update the location
         * 2. If not found add it to the map
         * 3. Finally update the friend record
         */
        let trackedPerson = LocationManager.sharedInstance.trackedPerson
        
        // 1. If found the anotation already just update the location
        if let index = self.familyPins.index(where: {$0.key == trackedPerson?.key}) {
            
            // Replace the annotation from our records
            let annotation = self.familyPins[index]

            // Update the new location with animation
            UIView.animate(withDuration: 0.50) {
                var location = annotation.coordinate
                location.latitude = latitude
                location.longitude = longitude
                annotation.coordinate = location
            }
        }
        // 2. If not found add it to the map
        else {
            
            // Prepare the anotation
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // Set the location and other details to annotation
            let annotation = FamilyAnnotation(location: location)
            annotation.title = trackedPerson?.displayName
            annotation.key = trackedPerson?.key
            
            locateMapView.addAnnotation(annotation)
            
            // Keep a note of this marker
            self.familyPins.append(annotation);
        }
    }
    
    func startObservingDB() {
    
        self.refHandle = dbRef.observe(.value, with: { (snapshot) in
            
            for snapshotItem in snapshot.children {
                
                if let trackedPerson = LocationManager.sharedInstance.trackedPerson {
                    
                    let user = User(snapshot: snapshotItem as! FIRDataSnapshot)
                    
                    if(user.email != trackedPerson.email) {
                        continue
                    }
                    
                    self.setLocation(latitude: user.latitude, longitude: user.longitude)
                    self.markLocation(latitude: user.latitude, longitude: user.longitude)
                    
                }
            }
            
        }) { (error) in
            // error handling
        }
    }
    
}
