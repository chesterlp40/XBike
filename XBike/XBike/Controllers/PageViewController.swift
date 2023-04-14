//
//  PageViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 10/04/2023.
//

import UIKit

class PageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    private let imageName: String
    private let subTitle: String
    private let isLastPage: Bool
    
    init(
        imageName: String,
        subTitle: String,
        isLastPage: Bool? = nil
    ) {
        self.imageName = imageName
        self.subTitle = subTitle
        self.isLastPage = isLastPage ?? false
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
    }
    
    private func setupComponents() {
        self.imageView.image = UIImage(
            named: self.imageName
        )
        self.subTitleLabel.text = self.subTitle
        self.actionButton.layer.cornerRadius = 8
        self.actionButton.isHidden = !self.isLastPage
    }
    
    @IBAction func actionButtonPressed(
        _ sender: UIButton
    ) {
        UserDefaults.standard.set(true, forKey: "isOnboardingDone")
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true)
    }
}
