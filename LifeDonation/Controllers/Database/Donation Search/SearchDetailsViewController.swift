//
//  DetailsAnnounceViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 17.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var callBarButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var bloodImageView: UIImageView!
    @IBOutlet weak var patientNearNameLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    //MARK: - Properties
    var phoneNumber : String?
    var databaseReference = Database.database().reference(withPath: "Users")
    var announce : Announcement!
    var alerPresent : AlertPresenter!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alerPresent = AlertPresenter(controller: self)
        fullFill()
    }
    
    //MARK: - Function
    func fullFill() {
        patientNameLabel.text = announce.patientName
        patientNearNameLabel.text = announce.patientNearName
        let imageName = announce.bloodType?.textToImage()
        bloodImageView.image = UIImage(named: imageName!)
        hospitalNameLabel.text = announce.hospitalName
        phoneNumber = announce.contactNumber
        contactNumberLabel.text = announce.contactNumber
        provinceLabel.text = announce.province
        noteLabel.text = announce.note
    }
    
    func dialNumber() {
        if let phone = phoneNumber, !phone.isEmpty {
            if let url = URL(string: "tel://\(phone)"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                let title = "Operation Failed"
                let  message = "Error in phone number"
                alerPresent.presentAlert(title: title, message: message)
            }
        } else {
            let title = "Operation Failed"
            let  message = "Error in phone number"
            alerPresent.presentAlert(title: title, message: message)
        }
    }
    
    //MARK: - Actions
    @IBAction func callBarButtonTapped(_ sender: UIBarButtonItem) {
        dialNumber()
    }
}
