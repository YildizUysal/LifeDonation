//
//  HistoryDetailViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 27.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var hemoglobinValueTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //MARK: - Properties
    var alertPresent : AlertPresenter?
    var height : String?
    var weight : String?
    var date : String?
    var hemoglobin : String?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresent = AlertPresenter(controller: self)
        
        heightTextField.inputAccessoryView = toolBar
        hemoglobinValueTextField.inputAccessoryView = toolBar
        weightTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolBar
    }
    
    //MARK: - Function
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        hemoglobin = hemoglobinValueTextField.text
        date = dateTextField.text
        weight = weightTextField.text
        height = heightTextField.text
//        if {
        performSegue(withIdentifier: "goBackToHistory", sender: nil)
//        } else {
//            let title = "İşlem Başarısız"
//            let message = "Bütün alanları doldurun."
//            alertPresent?.presentAlert(title: title, message: message)
//        }
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        dateTextField.text = ""
        weightTextField.text = ""
        heightTextField.text = ""
        hemoglobinValueTextField.text = ""
    }
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        let formatterString = DateFormat.formatter(selectedDate: datePicker.date)
              dateTextField.text = formatterString
    }
    
    @IBAction func stopBarButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    

}
