//
//  DateFormat.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 27.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import Foundation

class DateFormat {
    
    static func formatter(selectedDate: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = selectedDate 
        let formatterString = dateFormatter.string(from: selectedDate)
        return formatterString
    }
    
}
