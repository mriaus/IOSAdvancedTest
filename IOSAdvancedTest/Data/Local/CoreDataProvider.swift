//
//  CoreDataProvider.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 26/10/23.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    private let moc: NSManagedObjectContext
        
        init(context: NSManagedObjectContext) {
            self.moc = context
        }
    
    func saveCharacter(character: Character) {
        let _ = CharacterDAO(character: character, context: moc)
        try? moc.save()
    }
    
    func loadCharacters() -> Characters {
        let fetchCharacter = NSFetchRequest<CharacterDAO>(entityName: CharacterDAO.entityName)
        guard let characters = try? moc.fetch(fetchCharacter) else {
            print("Error loading entityName")
            return []
        }
        return characters.compactMap {$0.photo?.isEmpty == true ? nil : Character(characterDAO: $0)}
    }
    
    func deleteAllCharacters() {
        let fetchCharacter = NSFetchRequest<CharacterDAO>(entityName: CharacterDAO.entityName)
       guard let characters = try? moc.fetch(fetchCharacter) else { return }
        characters.forEach { moc.delete($0) }
        try? moc.save()
    }
}
