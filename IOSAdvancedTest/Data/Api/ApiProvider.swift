//
//  ApiProvider.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import Foundation
protocol ApiProviderProtocol {
    func login(for user: String, with password: String)
    func getHeroes(by name: String?, token: String, completion: ((Characters) -> Void)?)
    func getLocations(by characterId: String?, token: String, completion: ((CharacterLocations) -> Void)?)
}

class ApiProvider: ApiProviderProtocol {
    private let apiBaseUrl = APIBASEURL
    private let endpoints = ENDPOINTS.self
    
    //    MARK: LOG IN
    func login(for user: String, with password: String) {
        guard let url = URL(string: "\(apiBaseUrl)\(endpoints.LOGIN)") else {
            NotificationCenter.default.post(name: NotificationCenter.APILOGINFAILEDNOTIFICATION, object: nil,userInfo: [NotificationCenter.ERRORLOGIN: "Login error"])
            return
        }
        
        guard let loginData = String(format: "%@:%@", user, password).data(using: .utf8)?.base64EncodedString() else {
            NotificationCenter.default.post(name: NotificationCenter.APILOGINFAILEDNOTIFICATION, object: nil,userInfo: [NotificationCenter.ERRORLOGIN: "Login error"])
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                NotificationCenter.default.post(name: NotificationCenter.APILOGINFAILEDNOTIFICATION, object: nil, userInfo: [NotificationCenter.ERRORLOGIN: "Login error"])
                return
            }
            
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else {
                NotificationCenter.default.post(name: NotificationCenter.APILOGINFAILEDNOTIFICATION, object: nil,userInfo: [NotificationCenter.STATUSCODEERROR: (response as? HTTPURLResponse)?.statusCode ?? "Unexpected error"])
                return
            }
            
            guard let responseData = String(data: data, encoding: .utf8) else {
                NotificationCenter.default.post(name: NotificationCenter.APILOGINFAILEDNOTIFICATION, object: nil,userInfo: [NotificationCenter.ERRORLOGIN: "Login error"])
                return
            }
            NotificationCenter.default.post(name: NotificationCenter.APILOGINNOTIFICATION,
            object: nil, userInfo: [NotificationCenter.TOKENKEY: responseData])
            
        }.resume()
    }
    //    MARK: GET HEROES
    func getHeroes(by name: String?, token: String, completion: ((Characters) -> Void)?) {
        guard let url = URL(string: "\(apiBaseUrl)\(endpoints.HEROES)") else {
            completion?([])
            return
        }
        let jsonData: [String: Any] = ["name": name ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        var urlRequest = URLRequest(url: url)
//        TODO: See how to refactor the headers
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion?([])
                return
            }
            
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }
            
            guard let characters = try? JSONDecoder().decode(Characters.self, from: data) else {
                completion?([])
                return
            }
            completion?(characters)
        }.resume()
    }
//    MARK: GET LOCATIONS
    func getLocations(by characterId: String?, token: String, completion: ((CharacterLocations) -> Void)?) {
        guard let url = URL(string: "\(apiBaseUrl)\(endpoints.LOCATION)") else {
            // TODO: MAndar notificacion con error
            completion?([])
            return
        }
        let jsonData: [String: Any] = ["id": characterId ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion?([])
                return
            }
            
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }
            
            guard let locations = try? JSONDecoder().decode(CharacterLocations.self, from: data) else {
                completion?([])
                return
            }
            completion?(locations)
        }.resume()
    }
    
    
}
