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
    private(set) var isTracking = false
    private(set) var path = GMSMutablePath()
    private(set) var polyline = GMSPolyline()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Ride"
        self.setupComponents()
    }
    
    private func setupComponents() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
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
        modal.timeLabel.text = "00 : 00 : 00"
        modal.startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        modal.stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
        self.view.addSubview(modal)
    }
    
    @objc
    func startButtonPressed() {
        guard let modal = self.modal else {
            return
        }
        if !self.isTracking {
            self.locationManager.startUpdatingLocation()
            self.polyline.map = self.mapView
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                self.timesUp += 1
                self.updateLabel(modal.timeLabel)
            }
            self.isTracking = true
        }
    }
    
    @objc
    func stopButtonPressed() {
        guard
            let modal = self.modal
        else {
            return
        }
        if isTracking {
            self.timer?.invalidate()
            self.timesUp = 0
            self.isTracking = false
            self.locationManager.stopUpdatingLocation()
            self.polyline.map = nil
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

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let camera = GMSCameraPosition.camera(
                withTarget: location.coordinate,
                zoom: 15
            )
            self.mapView.camera = camera
            self.mapView.settings.myLocationButton = true
            self.mapView.isMyLocationEnabled = true
            self.mapView.animate(to: camera)
            if self.isTracking {
                self.path.add(location.coordinate)
                self.polyline.path = self.path
                self.polyline.strokeColor = .blue
                self.polyline.strokeWidth = 5
                self.polyline.map = self.mapView
            }
        }
    }
}
