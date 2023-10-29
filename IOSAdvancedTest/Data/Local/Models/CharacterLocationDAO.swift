//
//  LocationDAO.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 27/10/23.
//

import Foundation
import CoreData

@objc(CharacterLocationDAO)
public class CharacterLocationDAO: NSManagedObject {
    // Mover a un fichero de constantes
    static let entityName = "CharacterLocationDAO"

    @NSManaged var id: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var date: String?
    @NSManaged var character: String?
}
