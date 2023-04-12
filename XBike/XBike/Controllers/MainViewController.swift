//
//  MainViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 11/04/2023.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
    }
    
    private func setupComponents() {
        self.setupControllers()
        self.setupImages()
        self.setupStyle()
    }
    
    private func setupControllers() {
        let currentRideViewController = UINavigationController(
            rootViewController: CurrentRideViewController()
        )
        currentRideViewController.title = "Current Ride"
        let myProgressViewController = UINavigationController(
            rootViewController: MyProgressViewController()
        )
        myProgressViewController.title = "My Progress"
        self.setViewControllers(
            [currentRideViewController, myProgressViewController],
            animated: false
        )
    }
    
    private func setupImages() {
        guard let items = self.tabBar.items else { return }
        let images = ["figure.outdoor.cycle", "medal.fill"]
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
    }
    
    private func setupStyle() {
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.tintColor = .orange
        self.tabBar.backgroundColor = .white
    }
}
