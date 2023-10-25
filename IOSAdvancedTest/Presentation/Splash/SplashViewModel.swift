//
//  SplashViewModel.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import Foundation

class SplashViewModel: SplashViewControllerDelegate {
    lazy var loginViewModel: LoginViewControllerDelegate = {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }()
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
     }
}
