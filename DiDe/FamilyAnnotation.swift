//
//  FamilyAnnotation.swift
//  DiDe
//
//  Created by Deepak SK on 1/07/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class FamilyAnnotation : NSObject, MKAnnotation {
    
    dynamic var coordinate : CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var key: String?
    
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }
}
