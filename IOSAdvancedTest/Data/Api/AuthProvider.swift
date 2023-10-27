//
//  AuthProvider.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 27/10/23.
//

import Foundation

class AuthProvider {
    static let shared = AuthProvider()
    private init(){}
    
    //TODO: Add here if the user is logged
    
    func logOut(){
        secureDataProvider.save(token: "")

    }
}
