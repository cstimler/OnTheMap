//
//  OTMClient.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var sessionId = ""
        static var key = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
        case postStudentLocation
        case putStudentLocation(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=200"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "\(objectId)"
            }
        }
    }
    
    
    
    
}
