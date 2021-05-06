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
        static var firstName: String!
        static var lastName: String!
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
        case postStudentLocation
        case putStudentLocation(String)
        case postUdacitySession
        case getPublicUserDataUdacity
        
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=200"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "\(objectId)"
            case .postUdacitySession: return Endpoints.base + "/session"
            case .getPublicUserDataUdacity: return Endpoints.base + "/users/" + Auth.key
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func PostSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print(username)
        print(password)
        var request = URLRequest(url: Endpoints.postUdacitySession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let Dict = IdDict(username: username, password: password)
        let body = Udacity(udacity: Dict)
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                
                completion(false, error)
                return
            }
            do {
               
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(SessionPost.self, from: newData)
                print(responseObject)
                Auth.key = responseObject.account.key
                print(Auth.key)
                Auth.sessionId = responseObject.session.id
                print(Auth.sessionId)
                completion(true, nil)
            } catch {
                completion(false, error)
                return
            }
        }
        task.resume()
    }
    
    class func GetPublicUserDataUdacity(completion: @ escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getPublicUserDataUdacity.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
                let responseObject = try decoder.decode(GetPublicUserData.self, from: newData)
              print(responseObject)
                Auth.firstName = responseObject.firstName
                Auth.lastName = responseObject.lastName
                print(responseObject.firstName)
                print(responseObject.lastName)
                print(responseObject.key)
                completion(true, nil) }
            
                    catch
                    {
                        completion(false, error)
                        return
                    }
                }
        task.resume()
            
        }
}

