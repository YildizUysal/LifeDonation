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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bloodtypeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    //MARK: - Properties
    var currentUser = [User]()
    var favoriteAnnounce = [Announcement]()
    var alertPresent : AlertPresenter?
    let authUID = Auth.auth().currentUser?.uid
    var databaseReference = Database.database().reference(withPath: "Users")
    var storageReferance = Storage.storage().reference(withPath: "UserImages")
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavoriteData()
        alertPresent = AlertPresenter(controller: self)
        databaseReference.observe(.value, with: { (snapshot) in
            if let receivedValue = snapshot.value as? [String : Any] {
                for value in receivedValue.values {
                    if let dictionary = value as? [String: Any] {
                        let getUser = User(dictionary: dictionary)
                        if self.authUID == getUser.uid {
                            self.currentUser.append(getUser)
                            UIView.animate(withDuration: 0.5) {
                                self.fullFill()
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
         self.collectionView.reloadData()
    }
    
    //MARK: - Function
    func getFavoriteData() {
        let favoriRef = databaseReference.child(authUID!).child("Favorite").ref
        favoriRef.observe(.value, with: { (snapshot) in
            if let receivedValue = snapshot.value as? [String : Any] {
                self.favoriteAnnounce.removeAll()
                for value in receivedValue.values {
                    if let dictionary = value as? [String: Any] {
                        let announce = Announcement(dictionary: dictionary)
                        self.favoriteAnnounce.append(announce)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

            }
        })
    }
    
    func fullFill() {
        for user in currentUser {
            guard let email = user.email,
                // let image = user.imageName,
                let phoneNumber = user.phoneNumber,
                let bloodType = BloodType.init(rawValue:  user.bloodType!.rawValue),
                let firstName = user.firstName,
                let lastName = user.lastName,
                let address = user.address,
                let birthDate = user.birthDate,
                !email.isEmpty, !firstName.isEmpty, !phoneNumber.isEmpty, !address.isEmpty,
                !birthDate.isEmpty, !lastName.isEmpty else {
                    let title = "Error"
                    let message = "Profil Bilgisi Alınamıyor."
                    alertPresent?.presentAlert(title: title, message: message)
                    return
            }
            phoneLabel.text = phoneNumber
            addressLabel.text = address
            birthDateLabel.text = birthDate
            emailLabel.text = email
            bloodtypeLabel.text = bloodType.rawValue
            fullNameLabel.text = firstName + " " + lastName
            if user.imageName == "" {
                self.profileImageView.image = UIImage(named: "logo")
            } else {
                if let imagePath = user.imageName {
                    storageReferance.child(imagePath).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                        if let imageData = data {
                            UIView.animate(withDuration: 0.3) {
                                let image = UIImage(data: imageData)
                                self.profileImageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteAnnounce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavProfileCell", for: indexPath) as? ProfileCollectionViewCell {
            let announce = favoriteAnnounce[indexPath.row]
            cell.prepareForDrawing(announce: announce)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
}
