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
    
    private let imageName: String
    private let subTitle: String
    
    init(
        imageName: String,
        subTitle: String
    ) {
        self.imageName = imageName
        self.subTitle = subTitle
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
        self.imageView.image = UIImage(
            named: self.imageName
        )
        self.subTitleLabel.text = self.subTitle
    }
}
