//
//  AlertPresenter.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 12.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit

class AlertPresenter {
    
    private var controller : UIViewController
    
    init(controller : UIViewController) {
        self.controller = controller
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor =  UIColor.init(named: "baseColor")
        let action  = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
//    func presentAlertActionSheetWithTextFieldArray(title: String, message: String, textFieldPlaceholder : [String], handler: ((UIAlertAction) -> Void)?) {
//        if title != "" && message != "" {
//            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
//            alert.view.tintColor =  UIColor.init(named: "baseColor")
//            for i in 0..<textFieldPlaceholder.count{
//                alert.addTextField { (textField) in
//                    textField.placeholder = textFieldPlaceholder[i]
//                }
//            }
//            let cancelAction  = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(cancelAction)
//            let saveAction  = UIAlertAction.init(title: "Save", style: .default, handler: handler)
//            alert.addAction(saveAction)
//            controller.present(alert, animated: true, completion: nil)
//        }
//
//    }
//
//    func presentAlertWithTextFieldArray(title: String, message: String, textFieldPlaceholder : [String], handler: ((UIAlertAction) -> Void)?) {
//        if title != "" && message != "" {
//            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
//            alert.view.tintColor =  UIColor.init(named: "baseColor")
//            for i in 0..<textFieldPlaceholder.count{
//                alert.addTextField { (textField) in
//                    textField.placeholder = textFieldPlaceholder[i]
//                }
//            }
//            let cancelAction  = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(cancelAction)
//            let saveAction  = UIAlertAction.init(title: "Save", style: .default, handler: handler)
//            alert.addAction(saveAction)
//            controller.present(alert, animated: true, completion: nil)
//        }
//
//    }
    
    func presentAlertWithActionArray(title: String, message: String, actionsName: [String]){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor =  UIColor.init(named: "baseColor")
        //        alert.view.backgroundColor =  .white // Köşeler kare olur
        for i in 0..<actionsName.count {
            let alertAction = UIAlertAction.init(title: actionsName[i], style: .default, handler: nil)
            alert.addAction(alertAction)
        }
        controller.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertwithIdentifier(title: String, message: String, identifier: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor =  UIColor.init(named: "baseColor")
        
        let action  = UIAlertAction.init(title: "Tamam",  style: .default) { (action) in
            self.controller.performSegue(withIdentifier: identifier, sender: nil)
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
