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
    }
}

extension MyProgressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 3
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        // let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // cell.textLabel?.text = "Hello World"
        return UITableViewCell() // cell
    }
}
