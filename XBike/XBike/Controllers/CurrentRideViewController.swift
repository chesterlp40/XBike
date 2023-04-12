//
//  CurrentRideViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 11/04/2023.
//

import CoreLocation
import GoogleMaps
import UIKit

class CurrentRideViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!

    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Ride"
        
        self.locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            self.locationManager.requestLocation()
        case .authorizedWhenInUse:
            self.locationManager.requestLocation()
        case .denied:
            return
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.locationManager.requestWhenInUseAuthorization()
        default:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        let coordenates = CLLocationCoordinate2D(
            latitude: self.locationManager.location?.coordinate.latitude ?? 0.0,
            longitude: self.locationManager.location?.coordinate.longitude ?? 0.0
        )
        self.mapView.camera = GMSCameraPosition(
            target: coordenates,
            zoom: 8,
            bearing: 0,
            viewingAngle: 0
        )
        let marker = GMSMarker()
        marker.position = coordenates
        marker.title = "Hey Hi!"
        marker.snippet = "I'm here"
        marker.map = mapView
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error)
    }
}
