//
//  CharacterController.swift
//  MarvelCharacters
//
//  Created by Ethan Scott on 12/11/21.
//

import Foundation
import UIKit

struct CharacterController {
    
    static let publicAPIKey = "660a64f26015d95609404cef2b063ae6"
    static let privateAPIKey = "01c6acc5be8e0352cd88f5fea717df58228a6732"
    
    static func fetchAllCharacters(offset: Int, completion: @escaping (Result<([Character], Int), FetchError>) -> Void) {
        
        let limit = "20"
        let timestamp = Date().timeIntervalSince1970.description
        let combinedString = timestamp + privateAPIKey + publicAPIKey
        let hash = getMD5Hash(string: combinedString)
        
        guard let url = URL(string: "https://gateway.marvel.com/v1/public/characters?offset=\(String(offset))&limit=\(limit)&ts=\(timestamp)&apikey=\(publicAPIKey)&hash=\(hash)") else {return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
           
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let characterData = topLevelObject.data
                let results = characterData.results
                let totalResults = characterData.total
                
                completion(.success((results, totalResults)))
                
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchCharactersWith(searchTerm: String, offset: Int, completion: @escaping (Result<([Character], Int), FetchError>) -> Void) {

        let modifiedSearch = searchTerm.replacingOccurrences(of: " ", with: "%20")
        let limit = "20"
        let timestamp = Date().timeIntervalSince1970.description
        let combinedString = timestamp + privateAPIKey + publicAPIKey
        let hash = getMD5Hash(string: combinedString)
        
        guard let url = URL(string: "https://gateway.marvel.com/v1/public/characters?nameStartsWith=\(modifiedSearch)&offset=\(String(offset))&limit=\(limit)&ts=\(timestamp)&apikey=\(publicAPIKey)&hash=\(hash)") else {return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }

            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let characterData = topLevelObject.data
                let results = characterData.results
                let totalResults = characterData.total
                
                completion(.success((results, totalResults)))
   
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchCharacterImage(for character: Character, completion: @escaping (Result<UIImage, FetchError>)-> Void) {
        
        let urlPath = character.thumbnail.urlPath
        let urlExtension = character.thumbnail.urlExtension
        
        guard let imageURL = URL(string: urlPath + "." + urlExtension) else {return completion(.failure(.invalidURL))}

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}

            guard let image = UIImage(data: data) else {return completion(.failure(.couldntGetImage))}
            
            completion(.success(image))
            
        }.resume()
    }
    
}
