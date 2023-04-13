//
//  CustomStyleView.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 12/04/2023.
//

import UIKit

class CustomStyleView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
