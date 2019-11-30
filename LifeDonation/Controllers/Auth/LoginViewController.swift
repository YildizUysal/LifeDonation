//
//  ViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 10.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotificationsUI
import UserNotifications

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    var alertPresenter : AlertPresenter!
    var storage = UserDefaults.standard
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (sucess, _) in }
        
        alertPresenter = AlertPresenter(controller: self)
        let userData  = storage.value(forKey: "user") as? Data
        if userData != nil {
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(User.self, from: userData!)
                let mail = String(data.email!)
                let pass = String(data.password!)
                emailTextField.text = mail
                passwordTextField.text = pass
            } catch {
                let title = "Operation Failed"
                let message = "No previous login. Error: \(error)"
                alertPresenter.presentAlert(title: title, message: message)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData  = storage.value(forKey: "user") as? Data
        if userData != nil {
            self.performSegue(withIdentifier: "LoginToHome", sender: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func stopBarButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard  let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty else {
                let title = "Operation Failed"
                let message = "Your operation can not take place. Enter email and password."
                self.alertPresenter.presentAlert(title: title, message: message)
                return
        }
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            self.activityIndicator.stopAnimating()
            if error == nil && result?.user != nil  {
                let userDictionary = [
                    "email" : email,
                    "password" : password]
                let user = User.init(dictionary: userDictionary)
                let encoder = JSONEncoder()
                do {
                    let contactData = try encoder.encode(user)
                    self.storage.setValue(contactData, forKey: "user")
                    let title = "Operation Successful"
                    let message = "Welcome again."
                    self.alertPresenter.presentAlertwithIdentifier(title: title, message: message, identifier: "LoginToHome")
                } catch {
                    print(error)
                }
            }
            let title = "Operation Failed"
            let message = "Wrong email and password. Please check and try again."
            self.alertPresenter.presentAlert(title: title, message: message)
        }
    }
}

