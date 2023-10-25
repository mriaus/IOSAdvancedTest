//
//  SecureDataProvider.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataProviderProtocol {
    func save(token: String)
    func getToken() -> String?
}

class SecureDataProvider: SecureDataProviderProtocol {
    private let keychain = KeychainSwift()
    
    func save(token: String) {
        keychain.set(token, forKey: KeychainValues.TOKEN)
    }
    
    func getToken() -> String? {
        keychain.get(KeychainValues.TOKEN)
    }
    
}
