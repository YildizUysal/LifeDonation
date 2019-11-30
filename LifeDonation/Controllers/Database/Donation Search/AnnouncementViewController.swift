//
//  AddDonationViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 15.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AnnouncementViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var bloodTypeTextField: UITextField!
    @IBOutlet weak var patientNameTextField: UITextField!
    @IBOutlet weak var patientNearNameTextField: UITextField!
    @IBOutlet weak var hospitalNameTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var bloodTypePickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //MARK: - Properties
    var alertPresent : AlertPresenter!
    var databaseReferance : DatabaseReference!
    var announce : Announcement!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresent = AlertPresenter(controller: self)
        bloodTypeTextField.inputView = bloodTypePickerView
        patientNearNameTextField.inputAccessoryView = toolBar
        hospitalNameTextField.inputAccessoryView = toolBar
        contactNumberTextField.inputAccessoryView = toolBar
        provinceTextField.inputAccessoryView = toolBar
        noteTextField.inputAccessoryView = toolBar
        bloodTypeTextField.inputAccessoryView = toolBar
        patientNameTextField.inputAccessoryView = toolBar
    }
    
    //MARK: - Actions
    @IBAction func stopBarButtonTapped(_ sender: UIBarButtonItem) {
        if sender.tag == 1 {
            dismiss(animated: true, completion: nil)
        } else {
            view.endEditing(true)
        }
    }
    
    @IBAction func addAnnouncementButtonTapped(_ sender: UIButton) {
        guard let category = Announcement.DonationCategory.init(rawValue: categorySegmentedControl.selectedSegmentIndex) else {
            let title = "Operation Failed"
            let message = "Fill in the fields. Check and try again."
            alertPresent.presentAlert(title: title, message: message)
            return
        }
        guard let bloodType = bloodTypeTextField.text,
            let patientName = patientNameTextField.text,
            let note = noteTextField.text,
            let hospitalName = hospitalNameTextField.text,
            let province = provinceTextField.text,
            let patientNearName = patientNearNameTextField.text,
            let contactNumber = contactNumberTextField.text,
            !bloodType.isEmpty, !patientName.isEmpty, !note.isEmpty, !hospitalName.isEmpty,
            !province.isEmpty, !patientNearName.isEmpty, !contactNumber.isEmpty
            else {
                let title = "Operation Failed"
                let message = "Fill in the fields. Check and try again."
                alertPresent.presentAlert(title: title, message: message)
                return
        }
        
        databaseReferance = Database.database().reference(withPath: category.textValue())
        let sharingUID =  Auth.auth().currentUser?.uid
        let announceDictionary = ["sharingUID" : sharingUID as Any,
                                  "patientName" : patientName,
                                  "bloodType" : bloodType,
                                  "hospitalName" : hospitalName,
                                  "patientNearName" : patientNearName,
                                  "contactNumber" : contactNumber,
                                  "province" : province,
                                  "note" : note
            ] as [String : Any]
        self.announce = Announcement(dictionary: announceDictionary)
        self.databaseReferance.childByAutoId().setValue(announceDictionary) { (error, databaseRef) in
            if error == nil {
                print("Duyuru işlemi başarılı")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Duyuru işlemi başarısız oldu")
            }
        }
        print("başarılı")
    }
    
}

// MARK: PickerView
extension AnnouncementViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BloodType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BloodType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow = BloodType.allCases[row]
        bloodTypeTextField.text = selectedRow.rawValue
        
    }
}
