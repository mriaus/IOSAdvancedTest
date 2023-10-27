//
//  Location.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 27/10/23.
//

import Foundation

typealias CharacterLocations = [CharacterLocation]

struct CharacterLocation: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case character = "hero"
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
    }
    
    let id: String?
    let latitude: String?
    let longitude: String?
    let date: String?
    let character: Character?
}
