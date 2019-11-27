//
//  ProfileViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 15.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bloodtypeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageAddedButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    //MARK: - Properties
    var currentUser = [User]()
    var alertPresent : AlertPresenter?
    let authUID = Auth.auth().currentUser?.uid
    var databaseReference = Database.database().reference(withPath: "Users")
    var storageReferance = Storage.storage().reference(withPath: "ProfileImage")
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if profileImageView.image == nil {
//            imageAddedButton.isHidden = false
        }
        alertPresent = AlertPresenter(controller: self)
        databaseReference.observe(.value, with: { (snapshot) in
            if let receivedValue = snapshot.value as? [String : Any] {
                for value in receivedValue.values {
                    if let dictionary = value as? [String: Any] {
                        let getUser = User(dictionary: dictionary)
                        if self.authUID == getUser.uid {
                            self.currentUser.append(getUser)
                            self.fullFill()
                        }
                    }
                }
            }
        })
    }
    
    //MARK: - Function
    //    func getProfileImage() {
    //        var databaseReference = Database.database().reference(withPath: "Users")
    //
    //    }
    //
    
    func  fullFill() {
        for user in currentUser {
            guard
                let email = user.email,
                // let image = user.imageName,
                let phoneNumber = user.phoneNumber,
                let bloodType = BloodType.init(rawValue:  user.bloodType!.rawValue),
                let firstName = user.firstName,
                let lastName = user.lastName,
                !email.isEmpty, !firstName.isEmpty, !phoneNumber.isEmpty,
                !lastName.isEmpty else {
                    let title = "Hata"
                    let message = "Profil Bilgisi Alınamıyor."
                    alertPresent?.presentAlert(title: title, message: message)
                    return
            }
            phoneLabel.text = phoneNumber
            bloodtypeLabel.text = bloodType.rawValue
            fullNameLabel.text = firstName + " " + lastName
            //  if profileImageView.image == nil {
            //    imageAddedButton.isHidden = true
            //  }
        }
    }
    
    //MARK: - Actions
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Fotoğraf Seçin", message: "", preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction.init(title: "Camera", style: .default) { (actionAlert) in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let actionPhotoLibrary = UIAlertAction.init(title: "Photo Library", style: .default) { (actionAlert) in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let actionPhotoAlbum = UIAlertAction.init(title: "Save Album", style: .default) { (actionAlert) in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        alert.addAction(actionCamera)
        alert.addAction(actionPhotoAlbum)
        alert.addAction(actionPhotoLibrary)
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            self.profileImageView.image = editImage
        }
        dismiss(animated: true, completion: nil)
    }
}
