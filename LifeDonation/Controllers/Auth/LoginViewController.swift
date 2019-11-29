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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    var alertPresenter : AlertPresenter!
    var storage = UserDefaults.standard
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    let title = "İşlem Başarısız"
                    let message = "Daha önce giriş yapılmamış.Error: \(error)"
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
    
    //MARK: - Function

    //MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard  let email = emailTextField.text,
                let password = passwordTextField.text,
                !email.isEmpty,
                !password.isEmpty else {
                        let title = "İşlem Başarısız"
                        let message = "İşleminiz gerçekleşmiyor. Email ve şifre giriniz."
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
                            let title = "İşlem Başarılı"
                            let message = "Tekrar Hoş Geldiniz."
                            self.alertPresenter.presentAlertwithIdentifier(title: title, message: message, identifier: "LoginToHome")
                        } catch {
                            print(error)
                        }
                }
                let title = "İşlem Başarısız"
                let message = "Email ve Şifre Yanlış olabilir."
                self.alertPresenter.presentAlert(title: title, message: message)
        }
    }
}

