//
//  HomeSearchTableViewCell.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 17.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit

class HomeSearchTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var bloodImageView: UIImageView!
    
    //MARK: - Function
    func prepareForDrawing(announcement : Announcement){
        patientNameLabel.text = announcement.patientName
        let imageName = BloodType(rawValue: announcement.bloodType!.rawValue)?.textToImage()
        bloodImageView.image = UIImage(named: imageName!)
    }
}
