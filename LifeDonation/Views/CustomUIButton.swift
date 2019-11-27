//
//  CustomUIButton.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 10.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUIButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        willSet (newRadiusValue) {
            self.layer.cornerRadius = newRadiusValue
        }
    }
}
