//
//  Users.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 10.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import Foundation

struct User: Codable {
        
    //MARK: - Properties
    var uid : String?
    var firstName   : String?
    var imageName   : String?
    var lastName    : String?
    var email       : String?
    var password    : String?
    var birthDate   : String?
    var bloodType   : BloodType?
    var gender      : Gender?
    var address     : String?
    var phoneNumber : String?
    
    //MARK: - Enum
    enum Gender: Int, CaseIterable, Codable {
        case female = 0
        case male = 1
        case other = 2
        
        func textValue() -> String {
             switch self {
             case .female:
                    return "Female"
             case .male:
                    return "Male"
             case .other:
                    return "Other"
            }
        }
    }
    
    //MARK: - init
    init(dictionary: [String: Any]) {
        uid         = dictionary["uid"] as? String
        imageName   = dictionary["imageName"] as? String
        firstName   = dictionary["firstName"] as? String
        lastName    = dictionary["lastName"] as? String
        email       = dictionary["email"] as? String
        password    = dictionary["password"] as? String
        birthDate   = dictionary["birthDate"] as? String
        bloodType   = (dictionary["bloodType"] as? BloodType.RawValue).map { BloodType(rawValue: $0) } ?? nil
        gender      = (dictionary["gender"] as? Gender.RawValue).map { User.Gender(rawValue: $0) } ?? nil
        address     = dictionary["address"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
    }
}
