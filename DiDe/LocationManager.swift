//
//  LocationManager.swift
//  DiDe
//
//  Created by Deepak SK on 1/07/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import Foundation
import CoreLocation
//import Parse

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // Singlton class to share this across the app
    static let sharedInstance = LocationManager();
    
    private var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var trackedPerson: User?
    var currentUser: User?
    
    
    private override init() {
        
        super.init();
        
        self.locationManager.delegate = self;
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            self.locationManager.requestAlwaysAuthorization()
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.activityType = .otherNavigation
    }
    
    func startTracking() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        self.locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: Location deligate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        //let latitude = (location?.coordinate.latitude)!
        //let longitude = (location?.coordinate.longitude)!
        
        // Update the current location
        self.currentLocation = location;
        
        // print(self.currentLocation)
        
        // Update the user object
        let prevLatitude = currentUser?.latitude
        let prevLongitude = currentUser?.longitude
        let currLatitude = location?.coordinate.latitude
        let currLongitude = location?.coordinate.longitude
        
        if(currentUser != nil && prevLatitude != currLatitude && prevLongitude != currLongitude) {
            currentUser?.latitude = currLatitude
            currentUser?.longitude = currLongitude
            
            // Update the location to DB
            currentUser?.updateLocation();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("Locate error:" + error.localizedDescription)
    }
    
    // MARK: Listening to external events
    
}

