//
//  CurrentRideViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 11/04/2023.
//

import UIKit
import GoogleMaps

class CurrentRideViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Ride"
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}
