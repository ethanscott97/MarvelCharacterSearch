//
//  MD5Conversion.swift
//  MarvelCharacters
//
//  Created by Ethan Scott on 12/11/21.
//

import Foundation
import CryptoKit

func getMD5Hash(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    
    let hash = digest.map {
        String(format: "%02hhx", $0)
    }.joined()

    return hash
}

