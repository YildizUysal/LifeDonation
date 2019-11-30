//
//  CustomHistoryTableViewCell.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 28.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit

class CustomHistoryTableViewCell: UITableViewCell {
    
    // MARK : UI Elements
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var hemoglobinValueLabel: UILabel!
    
    //MARK: - Function
    func prepareForDrawing(history : History){
        dateLabel.text = history.date
        if history.weight != ""  && history.height != "" {
            detailsLabel.text = "\(history.weight ?? "") / \(history.height ?? "")"
        } else if history.weight == ""  && history.height != "" {
            detailsLabel.text = "\(history.height ?? "")"
        } else if history.weight != ""  && history.height == "" {
            detailsLabel.text = "\(history.weight ?? "")"
        } else {
            detailsLabel.text = "No Found Any Details"
        }
        hemoglobinValueLabel.text = history.hemoglobin
    }
}
