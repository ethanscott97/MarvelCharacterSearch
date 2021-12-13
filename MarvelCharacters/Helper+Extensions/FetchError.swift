//
//  FetchError.swift
//  MarvelCharacters
//
//  Created by Ethan Scott on 12/11/21.
//

import Foundation
enum FetchError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    case couldntGetImage
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach the server."
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data, unable to Decode."
        case .couldntGetImage:
            return "couldn't get image from data"
        }
    }
}
