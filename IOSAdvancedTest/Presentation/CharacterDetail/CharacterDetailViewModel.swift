//
//  CharacterDetailViewModel.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 26/10/23.
//

import Foundation

class CharacterDetailViewModel: CharacterDetailDelegate {
    var viewState: ((CharacterDetailViewState) -> Void)?
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private var character: Character
    private var characterLocations: CharacterLocations = []
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    init(character:Character, apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol){
        self.character = character
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onViewAppear(){
        viewState?(.loading(true))
        
        DispatchQueue.global().async{ [weak self] in
            defer { self?.viewState?((.loading(false))) }
            guard let token = self?.secureDataProvider.getToken() else {
                return
            }
            
            self?.apiProvider.getLocations(by: self?.character.id, token: token){ locations in
                self?.characterLocations = locations
                self?.viewState?(.update(character: self?.character, locations: self?.characterLocations))
            }
        }
    }
    
    func logOutPressed() {
        //        Remove the token
        secureDataProvider.save(token: "")
        //        changeViewState to do the navigation
        self.viewState?(.navigateToLogin)
    }
    
    func goBackPressed() {
        self.viewState?(.goBack)
    }
    
}
