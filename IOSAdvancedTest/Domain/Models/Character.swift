//
//  Character.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 26/10/23.
//

import Foundation

typealias Characters = [Character]

struct Character: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case isFavorite = "favorite"
    }
    
    let id: String?
    let name: String?
    let description: String?
    let photo: URL?
    let isFavorite: Bool?
}

extension Character {
    init(characterDAO: CharacterDAO) {
        id = characterDAO.id
        name = characterDAO.name
        description = characterDAO.characterDescription
        if let photoString = characterDAO.photo, let photoURL = URL(string: photoString) {
            photo = photoURL
        } else {
            photo = nil
        }
        isFavorite = characterDAO.favorite
    }
}
