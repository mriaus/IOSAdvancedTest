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
    lazy var charactersViewModel: CharactersViewControllerDelegate = {
        CharactersViewModel(apiProvider: apiProvider, dataProvider: secureDataProvider)
    }()
    lazy var tabBarViewModel: TabBarViewControllerDelegate = {
        TabBarViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider ,charactersViewModel: charactersViewModel, locationsViewModel: LocationsViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider ) )
    }()
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    var viewState: ((SplashViewState) -> Void)?

    
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
     }
    
    func getToken() {
        guard let token = secureDataProvider.getToken() else {
            self.viewState?(.navigateToLogin)
            return
        }
        if(token.isEmpty) {
            self.viewState?(.navigateToLogin)
        } else {
            self.viewState?(.navigateToList)
        }
    }
}
