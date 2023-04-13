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
    
    private var context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    private(set) var trackingModal: RideTrackingModalView?
    private(set) var storeDataModal: StoreTrackingModalView?
    private(set) var lastLocation: CLLocation?
    private(set) var timer: Timer?
    private(set) var timesUp = 0
    private(set) var totalTime = ""
    private(set) var isTracking = false
    private(set) var distancePath: Double = 0
    private(set) var streetStart = ""
    private(set) var streetFinish = ""
    private let locationManager = CLLocationManager()
    private let path = GMSMutablePath()
    private let polyline = GMSPolyline()
    private let geocoder = GMSGeocoder()
    
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
        self.setupModals()
    }
    
    private func setupNavigationBar() {
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
    
    private func setupModals() {
        self.trackingModal = RideTrackingModalView(
            frame: self.view.frame
        )
        self.trackingModal?.startButton.addTarget(
            self,
            action: #selector(startButtonPressed),
            for: .touchUpInside
        )
        self.trackingModal?.stopButton.addTarget(
            self, action:
            #selector(stopButtonPressed),
            for: .touchUpInside
        )
        self.storeDataModal = StoreTrackingModalView(
            frame: self.view.frame
        )
        self.storeDataModal?.infoView.isHidden = false
        self.storeDataModal?.storedView.isHidden = true
        self.storeDataModal?.storeButton.addTarget(
            self,
            action: #selector(storeButtonPressed),
            for: .touchUpInside
        )
        self.storeDataModal?.deleteButton.addTarget(
            self,
            action: #selector(deleteButtonPressed),
            for: .touchUpInside
        )
        self.storeDataModal?.okButton.addTarget(
            self,
            action: #selector(okButtonPressed),
            for: .touchUpInside
        )
    }
    
    @objc
    func onTrackPressed() {
        guard let modal = self.trackingModal else {
            return
        }
        self.storeDataModal?.infoView.isHidden = false
        self.storeDataModal?.storedView.isHidden = true
        modal.timeLabel.text = "00 : 00 : 00"
        self.view.addSubview(modal)
    }
    
    @objc
    func startButtonPressed() {
        guard
            let modal = self.trackingModal,
            let location = self.mapView.myLocation
        else {
            return
        }
        if !self.isTracking {
            self.lastLocation = location
            self.geocoder.reverseGeocodeCoordinate(location.coordinate) { response, error in
                guard
                    let address = response?.firstResult(),
                    let street = address.thoroughfare
                else {
                    return
                }
                self.streetStart = street
            }
            self.locationManager.startUpdatingLocation()
            self.polyline.map = self.mapView
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                self.timesUp += 1
                self.updateLabel(modal.timeLabel)
            }
            self.isTracking = true
        }
    }
    
    @objc
    func stopButtonPressed() {
        guard
            let modal = self.trackingModal,
            let location = self.mapView.myLocation
        else {
            return
        }
        if
            let mainModal = self.storeDataModal,
            self.isTracking
        {
            self.geocoder.reverseGeocodeCoordinate(location.coordinate) { response, error in
                guard
                    let address = response?.firstResult(),
                    let street = address.thoroughfare
                else {
                    return
                }
                self.streetFinish = street
            }
            self.totalTime = modal.timeLabel.text!
            self.timer?.invalidate()
            self.timesUp = 0
            self.isTracking = false
            self.locationManager.stopUpdatingLocation()
            self.path.removeAllCoordinates()
            mainModal.timeLabel.text = self.totalTime
            let kmDistance = self.distancePath / 1000
            let prettyDistance = String(format: "%.2f km", kmDistance)
            mainModal.distanceLabel.text = prettyDistance
            self.view.addSubview(mainModal)
        }
        modal.removeFromSuperview()
    }
    
    @objc
    func storeButtonPressed() {
        guard
            let modal = self.storeDataModal
        else {
            return
        }
        self.saveData()
        self.polyline.map = nil
        self.storeDataModal?.infoView.isHidden = true
        self.storeDataModal?.storedView.isHidden = false
    }
    
    @objc
    func deleteButtonPressed() {
        guard
            let modal = self.storeDataModal
        else {
            return
        }
        self.polyline.map = nil
        modal.removeFromSuperview()
    }
    
    @objc
    func okButtonPressed() {
        guard
            let modal = self.storeDataModal
        else {
            return
        }
        modal.removeFromSuperview()
    }
    
    private func saveData() {
        let trackingModel = TrackingModel(
            context: self.context
        )
        trackingModel.time = self.totalTime
        trackingModel.streetStart = !self.streetStart.isEmpty ? self.streetStart : "Unknown"
        trackingModel.streetFinish = !self.streetFinish.isEmpty ? self.streetFinish : "Unknown"
        let kmDistance = self.distancePath / 1000
        let prettyDistance = String(format: "%.2f km", kmDistance)
        trackingModel.distance = prettyDistance
        
        try? self.context.save()
    }
    
    func updateLabel(
        _ label: UILabel
    ) {
        let minutes = self.timesUp / 6000
        let seconds = (self.timesUp % 6000) / 100
        let hundredths = self.timesUp % 100
        DispatchQueue.main.async {
            label.text = String(
                format: "%02d : %02d : %02d",
                minutes,
                seconds,
                hundredths
            )
        }
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
                self.polyline.strokeColor = .orange
                self.polyline.strokeWidth = 5
                self.polyline.map = self.mapView
                
                if self.lastLocation == nil {
                    self.lastLocation = location
                }
                
                let distance = location.distance(
                    from: self.lastLocation!
                )
                self.distancePath += distance
            }
        }
    }
}
