//
//  RegisterViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 12.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var bloodTypeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var closePickersBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var bloodTypePicker: UIPickerView!
    @IBOutlet weak var barToolBar: UIToolbar!
    
    //MARK: - Properties
    var storage = UserDefaults.standard
    var databaseReferance : DatabaseReference!
    var alertPresenter : AlertPresenter!
    var user : User?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.inputAccessoryView = barToolBar
        lastNameTextField.inputAccessoryView = barToolBar
        phoneNumberTextField.inputAccessoryView = barToolBar
        emailTextField.inputAccessoryView = barToolBar
        passwordTextField.inputAccessoryView = barToolBar
        addressTextField.inputAccessoryView = barToolBar
        birthDateTextField.inputView = birthDatePicker
        birthDateTextField.inputAccessoryView = barToolBar
        bloodTypeTextField.inputView = bloodTypePicker
        bloodTypeTextField.inputAccessoryView = barToolBar
        databaseReferance = Database.database().reference(withPath: "Users")
        
        alertPresenter = AlertPresenter(controller: self)
    }
    
    //MARK: - Actions
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let bloodType = bloodTypeTextField.text,
            let gender = User.Gender(rawValue: genderSegmentedControl.selectedSegmentIndex)?.textValue(),
            let address = addressTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let birthDate = birthDateTextField.text,
            !bloodType.isEmpty, !address.isEmpty, !email.isEmpty,
            !firstName.isEmpty, !birthDate.isEmpty, !phoneNumber.isEmpty,
            !lastName.isEmpty, !password.isEmpty  else {
                let title = "Operation Failed"
                let message = "Your operation can not take place. Enter Email and Password."
                self.alertPresenter.presentAlert(title: title, message: message)
                return
        }
        activityIndicator.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil && result?.user != nil {
                let uid = Auth.auth().currentUser?.uid
                let imageName = ""
                let userDictionary = [
                    "uid": uid as Any,
                    "firstName" : firstName,
                    "imageName" : imageName,
                    "lastName" : lastName,
                    "email" : email,
                    "password" : password,
                    "birthDate" : birthDate,
                    "bloodType" : bloodType,
                    "gender" : gender,
                    "address" : address,
                    "phoneNumber" : phoneNumber
                    ] as [String : Any]
                self.user = User(dictionary: userDictionary)
                self.databaseReferance.child(uid!).setValue(userDictionary) { (error, dataRef) in
                    if error == nil {
                        let encoder = JSONEncoder()
                        do {
                            let contactData = try encoder.encode(self.user)
                            self.storage.setValue(contactData, forKey: "user")
                        } catch {
                            print(error)
                        }
                    } else {
                        print("Database işlemi hatalı")
                        print("Kişi kaydedilmedi.")
                        self.activityIndicator.stopAnimating()
                    }
                }
                self.activityIndicator.stopAnimating()
                let title = "Operation Successful"
                let message = "Your operation has been completed. You can now start using the app."
                self.alertPresenter.presentAlertwithIdentifier(title: title, message: message, identifier: "RegisterToHome")
            }
            self.activityIndicator.stopAnimating()
            let title = "Operation Failed"
            let message = "Email and Password may be wrong."
            self.alertPresenter.presentAlert(title: title, message: message)
        }
    }
    
    @IBAction func dateTimePickerChanged(_ sender: UIDatePicker) {
        let formatterString = DateFormat.formatter(selectedDate: birthDatePicker.date)
        birthDateTextField.text = formatterString
    }
    
    @IBAction func closeBarButtonItem(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            dismiss(animated: true, completion: nil)
        }
        else if sender.tag == 1 {
            view.endEditing(true)
        }
    }
    
    
}

// MARK: - PickerView
extension RegisterViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        let selectedBloodType = BloodType.allCases[row]
        bloodTypeTextField.text = selectedBloodType.rawValue
    }
    
}
