//
//  SessionPostRequest.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

struct IdDict: Codable {
    let username: String
    let password: String
}

struct Udacity: Codable {
    let udacity: IdDict
}
