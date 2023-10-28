//
//  LocationsViewModel.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 28/10/23.
//

import Foundation

class LocationsViewModel: LocationsViewControllerDelegate {
    var viewState: ((LocationsViewControllerStates) -> Void)?
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private var locations: CharacterLocations = []
    private var characters: Characters = []
    
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol){
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        //Create the dispatchGroup needed to the sync
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }

            let coreDataProvider = CoreDataProvider(context: AppDelegate().persistentContainer.viewContext)

            self?.characters = coreDataProvider.loadCharacters()
            guard let token = self?.secureDataProvider.getToken() else {
                return
            }

            self?.characters.forEach { character in
                //adds the transaction to the dispatch
                dispatchGroup.enter()
                self?.apiProvider.getLocations(by: character.id, token: token) { locations in
                    locations.forEach { location in
                        self?.locations.append(location)
                    }
                    //Notify that the transaction ended
                    dispatchGroup.leave()
                }
            }
            //Run this code only when all did the leave
            dispatchGroup.notify(queue: .main) {
                self?.viewState?(.update(characters: self?.characters, locations: self?.locations))
            }
        }
    }

}
