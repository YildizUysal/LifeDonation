//
//  HistoryViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 27.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HistoryViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    
    //MARK: - Properties
    var alertPresenter : AlertPresenter!
    var historyArray = [History]()
    var currentUserid : String = Auth.auth().currentUser!.uid
    var databaseReferance = Database.database().reference(withPath: "Users")
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(controller: self)
        getFirebaseHistoryValue()
        elementShowFunc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        elementShowFunc()
    }
    
    //MARK: - Function
    func elementShowFunc() {
        if historyArray.count > 0 {
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1
                self.infoView.alpha = 0
            }
        }
        else {
            UIView.animate(withDuration: 0.5) {
                           self.tableView.alpha = 0
                           self.infoView.alpha = 1
            }

        }
    }
    
    func getFirebaseHistoryValue() {
        let historyReferance = databaseReferance.child(currentUserid).child("History")
        historyReferance.observe(.value, with: { (snapshot) in
            self.historyArray.removeAll()
            if let receivedValue = snapshot.value as? [String : Any] {
                for value in receivedValue.values {
                    if let dictionary = value as? [String: Any] {
                        let history = History(dictionary: dictionary)
                        self.historyArray.append(history)
                        self.elementShowFunc()
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    //MARK: - Actions
    @IBAction func detailsHistory(_ sender: UIStoryboardSegue) {
        if let source = sender.source as? HistoryDetailViewController {
            let historyReferance = databaseReferance.child(currentUserid).child("History").childByAutoId()
            let autoID = historyReferance.key
            let historyDic = [
                "autoID" : autoID as Any,
                "weight" : source.weight as Any,
                "height" : source.height as Any,
                "hemoglobinValue" : source.hemoglobin as Any,
                "date" : source.date as Any
                ] as [String : Any]
            historyReferance.setValue(historyDic)
            let his = History(dictionary: historyDic)
            historyArray.append(his)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        elementShowFunc()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? CustomHistoryTableViewCell {
            let history = historyArray[indexPath.row]
            cell.prepareForDrawing(history: history)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completed) in
            let autoID = self.historyArray[indexPath.row].autoID
            if autoID != nil{
                let historyDeleteReferance = self.databaseReferance.child(self.currentUserid).child("History").child(autoID!)
                historyDeleteReferance.removeValue()
                self.historyArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                self.alertPresenter.presentAlert(title: "İşlem Hatası", message: "Küçük bir sorun oldu daha sonra tekrar deneyin.")
            }

            self.elementShowFunc()
            completed(true)
        }
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        } else {
            deleteAction.image = UIImage(named: "trash")
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
