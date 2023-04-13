//
//  StoreTrackingModalView.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 13/04/2023.
//

import UIKit

class StoreTrackingModalView: UIView {
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
    }
    
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        self.resourceSetup(
            frame: CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            )
        )
    }
    
    private func resourceSetup(
        frame: CGRect
    ) {
        let view = loadResource()
        view.frame = frame
        self.addSubview(view)
    }
    
    private func loadResource() -> UIView {
        let nib = UINib(
            nibName: "StoreTrackingModalView",
            bundle: Bundle.main
        )
        let view = nib.instantiate(withOwner: self).first as? UIView
        return view!
    }
}
