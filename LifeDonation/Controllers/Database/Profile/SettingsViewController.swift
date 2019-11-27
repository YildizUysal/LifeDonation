//
//  SettingsViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 27.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    // MARK: - UI Elements
    
    //MARK: - Properties
    let storage = UserDefaults.standard
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Function
    
    //MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem){
        do {
            try Auth.auth().signOut()
            storage.removeObject(forKey: "user")
            exit(0)
        } catch(let error) {
            print(error)
        }
    }
}
