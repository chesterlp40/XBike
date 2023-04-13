//
//  MyProgressViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 11/04/2023.
//

import CoreData
import UIKit

class MyProgressViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    internal var trackingData: [TrackingModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Progress"
        self.setupComponents()
        self.fetchInfo()
    }
    
    override func viewWillAppear(
        _ animated: Bool
    ) {
        self.fetchInfo()
        self.tableView.reloadData()
    }
    
    private func setupComponents() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(
            UINib(nibName: "RideTimesCell", bundle: nil),
            forCellReuseIdentifier: "RideTimesCell"
        )
    }
    
    internal func fetchInfo() {
        let request: NSFetchRequest<TrackingModel> = NSFetchRequest(
            entityName: "TrackingModel"
        )
        do {
            self.trackingData = try self.context.fetch(request)
        } catch {
            print(error)
        }
    }
}

extension MyProgressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.trackingData.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RideTimesCell", for: indexPath) as? RideTimesCell
        cell?.timeLabel?.text = self.trackingData[indexPath.row].time
        let streetStart = self.trackingData[indexPath.row].streetStart
        let streetFinish = self.trackingData[indexPath.row].streetFinish
        cell?.tripLabel.text = "A: \(streetStart ?? "Unknown")\nB: \(streetFinish ?? "Unknown")"
        cell?.distanceLabel.text = self.trackingData[indexPath.row].distance
        return cell!
    }
}
