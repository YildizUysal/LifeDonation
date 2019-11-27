//
//  HomeViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 13.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var categorieBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var databaseReferance : DatabaseReference?
    var searchingDonation = [Announcement]()
    var favAnnounce = [Announcement]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Blood Searching"
        getDataFirebaseForCategories(categoryName: "Kan")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    //MARK: - Function
    func getDataFirebaseForCategories(categoryName : String) {
        databaseReferance = Database.database().reference(withPath: categoryName)
        databaseReferance!.observe(.value, with: { (snapshot) in
            self.searchingDonation.removeAll()
            if let receivedValue = snapshot.value as? [String : Any] {
                for value in receivedValue.values {
                    if let dictionary = value as? [String: Any] {
                        let announcement = Announcement(dictionary: dictionary)
                        self.searchingDonation.append(announcement)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func animationNavigationTitle(title: String) {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = .fade
        self.navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        self.navigationItem.title = "\(title)"
    }
    
    //MARK: - Actions
    @IBAction func categorieBarButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Kategori Seç", message: " Bağış Kategorisi Seçiniz ", preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "Kan Donation", style: .default) { (action) in
            self.animationNavigationTitle(title: "Blood Searching")
            self.getDataFirebaseForCategories(categoryName: "Kan")
        }
        let action2 = UIAlertAction.init(title: "Aferez Donation", style: .default) { (action) in
            self.animationNavigationTitle(title: "Aferez Searching")
            self.getDataFirebaseForCategories(categoryName: "Aferez")
        }
        let action3 = UIAlertAction.init(title: "Kök Hücre Donation", style: .default) { (alertAction) in
            self.animationNavigationTitle(title: "Kök Hücre Searching")
            self.getDataFirebaseForCategories(categoryName: "KokHucre")
        }
        let action4 = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let destinationVC = segue.destination as! SearchDetailsViewController
            destinationVC.announce = sender as? Announcement
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingDonation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeSearchTableViewCell {
            let announce = searchingDonation[indexPath.row]
            cell.prepareForDrawing(announcement: announce)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announce = searchingDonation[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: announce)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addFavAction = UIContextualAction(style: .normal, title: "") { (_, _, completed) in
            let favoriAnnounce = self.searchingDonation[indexPath.row]
            self.favAnnounce.append(favoriAnnounce)
            print(self.favAnnounce.count)
            
            let uid = Auth.auth().currentUser!.uid
            let newFavRef = Database.database()
                .reference().child("Users").child(uid).child("Favorite").childByAutoId().ref
            let announceDictionary = ["sharingUID" : favoriAnnounce.sharingUID,
                                      "patientName" : favoriAnnounce.patientName,
                                      "bloodType" : favoriAnnounce.bloodType?.rawValue,
                                      "hospitalName" : favoriAnnounce.hospitalName,
                                      "patientNearName" : favoriAnnounce.patientNearName,
                                      "contactNumber" : favoriAnnounce.contactNumber,
                                      "province" : favoriAnnounce.province,
                                      "note" : favoriAnnounce.note
                      ] as [String : Any]
            newFavRef.setValue(announceDictionary)
            }
            if #available(iOS 13.0, *) {
                addFavAction.image = UIImage(systemName: "text.badge.plus")
            } else {
                addFavAction.image = UIImage(named: "plus")
            }
        addFavAction.backgroundColor = .some(UIColor(named: "baseColor")!)
            
        let configuration = UISwipeActionsConfiguration(actions: [addFavAction])
            
        return configuration
    }
    
}
