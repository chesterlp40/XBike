//
//  BaseViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 11/04/2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationStyle()
    }
    
    private func setupNavigationStyle() {
        let font = UIFont(
            name: "Kohinoor Telugu Light",
            size: 20
        )
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: font!]
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
    }
}
