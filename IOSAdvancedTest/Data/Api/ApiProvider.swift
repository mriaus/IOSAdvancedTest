//
//  ApiProvider.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import Foundation
protocol ApiProviderProtocol {
    func login(for user: String, with password: String)
}

class ApiProvider: ApiProviderProtocol {
    private let apiBaseUrl = APIBASEURL
    private let endpoints = ENDPOINTS.self
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
                // TODO: Notificación de fallo
                NotificationCenter.default.post(name: NotificationCenter.APILOGINFAILEDNOTIFICATION, object: nil, userInfo: [NotificationCenter.ERRORLOGIN: "Login error"])
                return
            }
            
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else {
                // TODO: Notificación de fallo
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
    
    
}
