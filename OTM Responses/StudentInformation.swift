//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

// The following struct can also be used to request an update or "PUT" for student location:
struct Models: Codable {
    var results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct StudentInformation: Codable {
    var createdAt: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String // not sure of this
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
        
    }
}
