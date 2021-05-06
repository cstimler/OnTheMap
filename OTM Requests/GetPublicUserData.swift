//
//  GetPublicUserData.swift
//  OnTheMap
//
//  Created by June2020 on 5/6/21.
//

import Foundation

struct GetPublicUserData : Codable {
let firstName : String
let lastName : String
let key : String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
