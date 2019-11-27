//
//  HistoryViewController.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 27.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var history = [History]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK: - Function
    
    //MARK: - Actions
    
    @IBAction func detailsHistory(_ sender: UIStoryboardSegue){
        if let source = sender.source as? HistoryDetailViewController {
            let historyDic = [
                        "weight" : source.weight as Any,
                        "height" : source.height as Any,
                        "hemoglobinValue" : source.hemoglobin as Any,
                        "date" : source.date as Any
                ] as [String : Any]
            let his = History(dictionary: historyDic)
            history.append(his)
        }
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
