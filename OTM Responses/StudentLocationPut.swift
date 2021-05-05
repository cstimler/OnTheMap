//
//  StudentLocationPut.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

struct StudentLocationPut: Codable {
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
       case updatedAt
    }
}
