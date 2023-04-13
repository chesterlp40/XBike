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
    
    internal let viewModel = TrackingDataViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Progress"
        self.setupComponents()
        self.viewModel.fetchInfo()
    }
    
    override func viewWillAppear(
        _ animated: Bool
    ) {
        self.viewModel.fetchInfo()
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
}

extension MyProgressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.viewModel.trackingData.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RideTimesCell", for: indexPath) as? RideTimesCell
        cell?.timeLabel?.text = self.viewModel.trackingData[indexPath.row].time
        let streetStart = self.viewModel.trackingData[indexPath.row].streetStart
        let streetFinish = self.viewModel.trackingData[indexPath.row].streetFinish
        cell?.tripLabel.text = "A: \(streetStart ?? "Unknown")\nB: \(streetFinish ?? "Unknown")"
        cell?.distanceLabel.text = self.viewModel.trackingData[indexPath.row].distance
        return cell!
    }
}
