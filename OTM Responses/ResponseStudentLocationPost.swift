//
//  ResponseStudentLocationPost.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

struct ResponseStudentLocationPost: Codable {
    var createdAt: String
    var objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
    
}
