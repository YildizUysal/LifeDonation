//
//  Announcement.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 16.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import Foundation

struct Announcement {
    
    var sharingUID : String?
    var patientName : String?
    var bloodType: BloodType?
    var donationCategory: DonationCategory?
    var hospitalName : String?
    var patientNearName : String?
    var contactNumber : String?
    var province: String?
    var note: String?
    
    enum DonationCategory : Int , CaseIterable {
              case kan = 0
              case aferez = 1
              case kokHucre = 2
        
        func textValue() -> String {
                   switch self {
                   case .kan:
                          return "Kan"
                   case .aferez:
                          return "Aferez"
                   case .kokHucre:
                          return "KokHucre"
                  }
              }
          }
    
    init(dictionary: [String: Any]) {
        sharingUID      = dictionary["sharingUID"] as? String
        patientName     = dictionary["patientName"] as? String
        bloodType       = (dictionary["bloodType"] as? BloodType.RawValue).map { BloodType(rawValue: $0) } ?? nil
        donationCategory = (dictionary["donationCategory"] as? DonationCategory.RawValue).map { Announcement.DonationCategory(rawValue: $0) } ?? nil
        hospitalName    = dictionary["hospitalName"] as? String
        patientNearName  = dictionary["patientNearName"] as? String
        contactNumber   =  dictionary["contactNumber"] as? String
        province        = dictionary["province"] as? String
        note            = dictionary["note"] as? String
    }
}
