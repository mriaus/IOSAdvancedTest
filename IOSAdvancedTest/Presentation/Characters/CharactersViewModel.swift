//
//  CharactersViewModel.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 25/10/23.
//

import Foundation
import CoreData

class CharactersViewModel: CharactersViewControllerDelegate {
    var viewState: ((CharacterViewState) -> Void)?
    private var characters: Characters = []
    var charactersCount: Int {
        characters.count
    }
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    
    init(apiProvider: ApiProviderProtocol, dataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = dataProvider
    }
    
    func characterDetailViewModel(index: Int) ->  CharacterDetailDelegate?{
        guard let selectedCharacter = characterBy(index: index) else {return nil}
        return CharacterDetailViewModel(character: selectedCharacter, apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    func onViewAppear() {
        NotificationCenter.default.removeObserver(self)
        let coreDataProvider = CoreDataProvider(context: AppDelegate().persistentContainer.viewContext)
        self.characters = coreDataProvider.loadCharacters()
        print(self.characters.count)
        if(self.characters.count < 1){
            //                Just call the api if no characters found
            print("Api data")
            getApiData()
        }
        self.viewState?(.updateData)
    }
    
    private func  getApiData(){
        DispatchQueue.global().async { [weak self] in
            guard let token = self?.secureDataProvider.getToken() else {return}
            self?.apiProvider.getCharacters(by: nil, token: token) { characters in
                self?.characters = characters
                self?.viewState?(.updateData)
                DispatchQueue.main.async {
                    let coreDataProvider = CoreDataProvider(context: AppDelegate().persistentContainer.viewContext)
                    for character in characters {
                        coreDataProvider.saveCharacter(character: character)
                    }
                }
            }
        }
    }
    
    
    func characterBy(index: Int) -> Character? {
        if index >= 0 && index < charactersCount {
            return characters[index]
        } else {
            return nil
        }
    }
    
    func onLogOutButtonPressed() {
//        Remove the core data items
        let coreDataProvider = CoreDataProvider(context: AppDelegate().persistentContainer.viewContext)
        coreDataProvider.deleteAllCharacters()
        
        //        Remove the token
        secureDataProvider.save(token: "")
        //        changeViewState to do the navigation
        self.viewState?(.navigateToLogin)
    }
    
}
