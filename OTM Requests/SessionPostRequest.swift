//
//  SessionPostRequest.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

struct IdDict: Codable {
    var username: String = ""
    var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}

struct Udacity: Codable {
    var udacity: IdDict
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
