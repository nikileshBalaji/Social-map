//
//  MapViewController.swift
//  ARText
//
//  Created by nikilesh balaji on 2/19/22.
//  Copyright © 2022 Mark Zhong. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager : LocationManager?
    var currentUserLocation : String?
    var location: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        // Do any additional setup after loading the view.
    }
    
    func initializeLocationManager(){
        self.locationManager = LocationManager()
        self.locationManager?.cllocationManager?.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let camera = GMSCameraPosition.camera(withLatitude: (locations.last?.coordinate.latitude)! , longitude: (locations.last?.coordinate.longitude)! , zoom: (self.locationManager?.zoomLevel)!)
        if self.locationManager?.mapView == nil {
            self.locationManager?.mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
            self.locationManager?.mapView.delegate = self
        }
        self.locationManager?.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.locationManager?.mapView.camera = camera
        self.locationManager?.mapView.isMyLocationEnabled = true
        self.locationManager?.mapView.settings.myLocationButton = true
        self.locationManager?.mapView.settings.compassButton =  true
        self.locationManager?.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        self.locationManager?.mapView.animate(to: camera)
        self.mapView.addSubview((self.locationManager?.mapView)!)
        self.currentUserLocation = "\((locations.last?.coordinate.latitude)!),\((locations.last?.coordinate.longitude)!)"
        placeMarker()
    }
    
    
    func placeMarker() {
        if let lat = getUserData(withKey: "lat") as? String,
           let lng = getUserData(withKey: "lng") as? String {
            let loc = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(lat)!), longitude: CLLocationDegrees(Double(lng)!))
               let marker = GMSMarker(position:loc)
                                 marker.icon = UIImage(named: "places")
                                 marker.map = self.locationManager?.mapView
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            showAlertPermissionNotgiven()
        case .denied:
            showAlertPermissionNotgiven()
            self.locationManager = nil
        case .notDetermined: fallthrough
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("success")
            self.locationManager?.cllocationManager?.startUpdatingLocation()
        @unknown default:
            showAlertPermissionNotgiven()
        }
    }
    
    func showAlertPermissionNotgiven() {
        let alertController = UIAlertController(title: "GPS SUPPORT", message: "Please Give Location Permission From Settings Inroder To Use The Application", preferredStyle: .alert)
        let actionOkay = UIAlertAction(title: "Okay", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, completionHandler: .none)
            }
        }
        alertController.addAction(actionOkay)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager?.cllocationManager?.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        self.location = coordinate
        marker.icon = UIImage(named: "places")
        marker.map = self.locationManager?.mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var eventDetail = storyboard.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailViewController
        eventDetail?.location = location
        self.modalPresentationStyle = .fullScreen
        self.present(eventDetail!, animated: true, completion: nil)
        return true
    }
    
}
