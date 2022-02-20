//
//  LocationManager.swift
//  ARText
//
//  Created by nikilesh balaji on 2/19/22.
//  Copyright © 2022 Mark Zhong. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation

class LocationManager {
    public var cllocationManager: CLLocationManager?
    public var currentLocation: CLLocation?
    public var mapView: GMSMapView!
    public var zoomLevel: Float = 17
    
    init() {
        cllocationManager = CLLocationManager()
        cllocationManager?.requestWhenInUseAuthorization()
        cllocationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        cllocationManager?.requestAlwaysAuthorization()
        cllocationManager?.distanceFilter = 50
        cllocationManager?.startUpdatingLocation()
    }
}
