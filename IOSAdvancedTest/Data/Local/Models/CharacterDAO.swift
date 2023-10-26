//
//  CharacterDAO.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 26/10/23.
//

import Foundation
import Foundation
import CoreData

@objc(CharacterDAO)
class CharacterDAO: NSManagedObject {
    // Mover a un fichero de constantes
    static let entityName = "CharacterDAO"
    
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var characterDescription: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
    
    convenience init(character: Character, context: NSManagedObjectContext) {
            self.init(context: context)
            id = character.id
            name = character.name
            characterDescription = character.description
            photo = character.photo?.absoluteString
            favorite = character.isFavorite ?? false
        }
}
