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
    private var logged: Bool
    private let apiProvider: ApiProviderProtocol
    private let dataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol, dataProvider: SecureDataProviderProtocol, logged: Bool?) {
        self.apiProvider = apiProvider
        self.dataProvider = dataProvider
        self.logged = logged ?? false
    }
    
    func onViewAppear() {
        DispatchQueue.global().async {
            guard let token = self.dataProvider.getToken() else {return}
            self.apiProvider.getHeroes(by: nil, token: token) { characters in
                self.characters = characters
                self.viewState?(.updateData)
                DispatchQueue.main.async {
                    let coreDataProvider = CoreDataProvider(context: AppDelegate().persistentContainer.viewContext)
                    for character in characters {
                        coreDataProvider.saveCharacter(character: character)
                    }
                    print(coreDataProvider.loadCharacters().count)
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
    
    
}