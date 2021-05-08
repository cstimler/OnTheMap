//
//  StudentInformationPost.swift
//  OnTheMap
//
//  Created by June2020 on 5/8/21.
//

import Foundation

struct StudentInformationPost: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String 
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
        
    }
}

