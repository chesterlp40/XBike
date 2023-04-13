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
    
    private(set) var modal: RideTrackingModalView?
    private(set) var timer: Timer?
    private(set) var locationManager = CLLocationManager()
    private(set) var timesUp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Ride"
        
        self.locationManager.delegate = self
        self.setupComponents()
    }
    
    private func setupComponents() {
        self.modal = RideTrackingModalView(
            frame: self.view.frame
        )
        let image = UIImage(systemName: "plus")
        let rightBarbutton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(onTrackPressed)
        )
        rightBarbutton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    @objc
    func onTrackPressed() {
        guard let modal = self.modal else {
            return
        }
        modal.startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        modal.stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
        self.view.addSubview(modal)
    }
    
    @objc
    func startButtonPressed() {
        guard let modal = self.modal else {
            return
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.timesUp += 1
            self.updateLabel(modal.timeLabel)
        }
    }
    
    @objc
    func stopButtonPressed() {
        guard
            let modal = self.modal
        else {
            return
        }
        if let timer = self.timer, timer.isValid {
            timer.invalidate()
        } else {
            modal.removeFromSuperview()
        }
    }
    
    func updateLabel(
        _ label: UILabel
    ) {
        let minutes = self.timesUp / 6000
        let seconds = (self.timesUp % 6000) / 100
        let hundredths = self.timesUp % 100
        label.text = String(
            format: "%02d : %02d : %02d", minutes, seconds, hundredths
        )
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
