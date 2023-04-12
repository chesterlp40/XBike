//
//  MyProgressViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 11/04/2023.
//

import UIKit

class MyProgressViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Progress"
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
        return 8
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RideTimesCell", for: indexPath) as? RideTimesCell
        cell?.timeLabel?.text = "10 : 34 : 12"
        cell?.tripLabel.text = "A: Suipacha 3544\nB: Luis Garcia 1355"
        cell?.distanceLabel.text = "34.3 Km"
        return cell!
    }
}
