//
//  History.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 27.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import Foundation

struct History {
    
    var height : String?
    var weight : String?
    var hemoglobin : String?
    var date : String?
    
    init(dictionary : [String : Any]) {
        height = dictionary["height"] as? String
        weight = dictionary["weight"] as? String
        hemoglobin = dictionary["hemoglobinValue"] as? String
        date = dictionary["historyDate"] as? String
    }
    
}
