//
//  Character Model.swift
//  MarvelCharacters
//
//  Created by Ethan Scott on 12/11/21.
//

import Foundation

struct TopLevelObject: Codable {
    var data: CharacterData
}

struct CharacterData: Codable {
    var total: Int
    var results: [Character]
}

struct Character: Codable {
    var name: String
    var description: String
    var thumbnail: Image
}

struct Image: Codable {
    var urlPath: String
    var urlExtension: String
    
    enum CodingKeys: String, CodingKey {
        case urlPath = "path"
        case urlExtension = "extension"
    }
}
