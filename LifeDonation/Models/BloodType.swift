//
//  BloodType.swift
//  LifeDonation
//
//  Created by Yıldız Uysal on 26.11.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import Foundation

enum BloodType : String , CaseIterable, Codable {
         case zeroPositiveType = "0 RH(+)"
         case zeroNegativeType = "0 RH(-)"
         case aPositiveType = "A RH(+)"
         case aNegativeType = "A RH(-)"
         case bPositiveType = "B RH(+)"
         case bNegativeType = "B RH(-)"
         case abPositiveType = "AB RH(+)"
         case abNegativeType = "AB RH(-)"
      
      func textToImage() -> String {
          var imageName = ""
                  switch self {
                  case .abNegativeType:
                      imageName  = "AB-Minus-TypeBlood"
                  case .abPositiveType:
                      imageName  = "AB-Plus-TypeBlood"
                  case .aNegativeType:
                      imageName  = "A-Minus-TypeBlood"
                  case .aPositiveType:
                      imageName  = "A-Plus-TypeBlood"
                  case .bNegativeType:
                      imageName  = "B-Minus-TypeBlood"
                  case .bPositiveType:
                      imageName  = "B-Plus-TypeBlood"
                  case .zeroNegativeType:
                      imageName  = "O-Minus-TypeBlood"
                  case .zeroPositiveType:
                      imageName  = "O-Plus-TypeBlood"
                  }
          return imageName
          }
     }
