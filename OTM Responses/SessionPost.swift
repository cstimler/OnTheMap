//
//  SessionPost.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
}
// struct Session can also be reused for the Udacity Delete request:
struct Session: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }
}

struct FirstLevelObject: Codable {
    let account: Account
    let session: Session
}

