//
//  SettingsViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 27.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UserNotificationsUI
import UserNotifications

class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    let storage = UserDefaults.standard
    var storageReference: StorageReference!
    var currentUser : User!
    var currentUserid : String = Auth.auth().currentUser!.uid
    var databaseReferance = Database.database().reference(withPath: "Users")
    var alertPresent : AlertPresenter!
    var settingsSection = [(title:String,content:[String])]()
    var triggerDelay = 5
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        storageReference = Storage.storage().reference(withPath: "UserImages")
        alertPresent = AlertPresenter(controller: self)
        settingsSection.append(
            (title: "Profile", content: [
                "Update Profile Picture",
                "Update Personal Information",
                //"Update Login Information",
                "Update Contact Information",
                "Update Notification"
            ]))
    }
    
    //MARK: - Function
    func updateFirebaseData(childName: String, childValue: String) {
        if childValue != "" && childName != ""{
            let usersRef = databaseReferance.child(currentUserid).ref
            usersRef.child(childName).setValue(childValue)
        }
    }
    
    func getFirebaseValue() {
        let databaseRef = databaseReferance.child(currentUserid)
        databaseRef.observe(.value, with: { (snapshot) in
            if let receivedValue = snapshot.value as? [String : Any] {
                for value in receivedValue.values {
                    if let dictionary = value as? [String: Any] {
                        let getUser = User(dictionary: dictionary)
                        self.currentUser = getUser
                    }
                }
            }
        })
    }
    
    func selectedProfileImage(){
        let alert = UIAlertController.init(title: "Select Photo", message: "Please select your profile photo", preferredStyle: .actionSheet)
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
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionCamera)
        alert.addAction(actionPhotoAlbum)
        alert.addAction(actionPhotoLibrary)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func notificationFunc(){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Life Donation"
        notificationContent.body = "Hey new announcements entered. You start using the application."
        notificationContent.sound = .default
        
        let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(triggerDelay), repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: "myNoti", content: notificationContent, trigger: timeIntervalTrigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
    }
    
    //MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem){
        do {
            try Auth.auth().signOut()
            notificationFunc()
            storage.removeObject(forKey: "user")
            exit(0)
        } catch(let error) {
            print(error)
        }
    }
    
    func settingsContent(content: String) {
        getFirebaseValue()
        let alert = UIAlertController(title: content, message: "Please fill in the area", preferredStyle: .alert)
        switch content {
        case "Update Profile Picture":
            selectedProfileImage()
        case "Update Personal Information":
            alert.addTextField { (textField) in
                textField.placeholder = "firstName"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "lastName"
            }
        case "Update Contact Information":
            alert.addTextField { (textField) in
                textField.placeholder = "address"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "phoneNumber"
            }
        case "Update Notification":
            alert.addTextField { (textField) in
                textField.placeholder = "Notification Second"
            }
        default:
            break
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Save", style: .default) { [weak self] (_) in
            for textfields in alert.textFields! {
                let firebaseValue = textfields.text
                let firebaseKey = textfields.placeholder
                if firebaseKey == "Notification Second" {
                    self?.triggerDelay = Int(firebaseValue!) ?? 5
                } else {
                    self?.updateFirebaseData(childName: firebaseKey ?? "", childValue: firebaseValue ?? "")
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ImagePicker
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            updateFirebaseData(childName: "imageName", childValue: "\(currentUserid)/")
            if let imageData = editImage.jpegData(compressionQuality: 0.5) // 0 ile 1 arası
            {
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                self.storageReference.child(currentUserid).putData(imageData, metadata: metadata) { (metaData, error) in
                    if error == nil {
                        print("Upload Successful")
                        //self.performSegue(withIdentifier: "goProfile", sender: nil)
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSection[section].content.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SettingsCell")!
        let content = settingsSection[indexPath.section].content[indexPath.row]
        cell.textLabel?.text = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSection[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = settingsSection[indexPath.section].content[indexPath.row]
        settingsContent(content: content)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Notification
extension SettingsViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

