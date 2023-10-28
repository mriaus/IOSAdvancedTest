//
//  TabBarViewModel.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 27/10/23.
//

import Foundation

class TabBarViewModel: TabBarViewControllerDelegate {
    var charactersViewModel: CharactersViewControllerDelegate
    var locationsViewModel: LocationsViewControllerDelegate
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol,secureDataProvider: SecureDataProviderProtocol,charactersViewModel: CharactersViewControllerDelegate,locationsViewModel: LocationsViewControllerDelegate
) {
        self.charactersViewModel = charactersViewModel
        self.apiProvider = apiProvider
        self.locationsViewModel = locationsViewModel
        self.secureDataProvider = secureDataProvider
    }
}
