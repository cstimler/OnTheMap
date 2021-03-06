//
//  OTMClient.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation


class OTMClient {
    
    typealias CLLocationDegrees = Double
    
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
        case deleteUdacitySession
        
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "\(objectId)"
            case .postUdacitySession: return Endpoints.base + "/session"
            case .getPublicUserDataUdacity: return Endpoints.base + "/users/" + Auth.key
            case .deleteUdacitySession: return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func postSession(username: String, password: String, completion: @escaping (Bool, Error?, String?) -> Void) {
        print(username)
        print(password)
        var request = URLRequest(url: Endpoints.postUdacitySession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let Dict = IdDict(username: username, password: password)
        let body = Udacity(udacity: Dict)
        request.httpBody = try! JSONEncoder().encode(body)
        // We don't want to wait too long before getting a connectivity error
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                
                DispatchQueue.main.async {
                    completion(false, error, "data nil")
                }
                return
            }
            do {
               
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(SessionPost.self, from: newData)
                //print(responseObject)
                Auth.key = responseObject.account.key
                Auth.sessionId = responseObject.session.id
                DispatchQueue.main.async {
                    completion(true, nil, "")
                }
            } catch {
                DispatchQueue.main.async {
                completion(false, error, "bad decode")
                }
                return
            }
        }
        task.resume()
    }
    
    class func getPublicUserDataUdacity(completion: @ escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getPublicUserDataUdacity.url)
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
          //    print(responseObject)
                Auth.firstName = responseObject.firstName
                Auth.lastName = responseObject.lastName
                completion(true, nil) }
                    catch
                    {
                        completion(false, error)
                        return
                    }
                }
        task.resume()
            
        }
    
    class func getStudentLocations(completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getStudentLocations.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(Models.self, from: data)
                    model = responseObject.results
                    completion(true, nil) }
                        catch
                        {
                            completion(false, error)
                            return
                        }
                    }
            task.resume()
                
            }
    
    class func postStudentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, addressString: String, mediaURL: String?, completion: @escaping (Bool, Error?, String?) -> Void) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = StudentInformationPost(uniqueKey: Auth.key, firstName: Auth.firstName, lastName: Auth.lastName, mapString: addressString, mediaURL: mediaURL ?? "", latitude: latitude, longitude: longitude)
        request.httpBody = try! JSONEncoder().encode(body)
        // We don't want to wait too long before getting a connectivity error
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error, " because of a server error.  Try again later.")
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseStudentLocationPost.self, from: data)
                print(responseObject)
                completion(true, nil, "")
            } catch {
                print("Posting failed")
                completion(false, error, " Try again.")
                return
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.deleteUdacitySession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        { data, response, error in
            if error != nil {
                completion()
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    }


