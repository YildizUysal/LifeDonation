//
//  ProfileCollectionViewCell.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 29.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientBloodImage: UIImageView!
       
       // MARK: - Functions
       func prepareForDrawing(announce: Announcement) {
        phoneLabel.text = announce.contactNumber
        patientBloodImage.image = UIImage(named: (announce.bloodType?.textToImage())!)
        hospitalNameLabel.text = announce.hospitalName
        patientNameLabel.text = announce.patientName
       }
}
