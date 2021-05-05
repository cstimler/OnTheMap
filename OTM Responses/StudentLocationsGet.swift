//
//  StudentLocationsGet.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

struct LocationDetails: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let objectID: String
    let uniqueKey: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case objectID
        case uniqueKey
        case updatedAt
    }
}

struct Results: Codable {
    let results: [LocationDetails]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct StudentLocations: Codable {
    let topLevel: Results
}
