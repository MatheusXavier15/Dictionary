//
//  DefinitionModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation

struct Definition: Decodable {
    let definition: String
    let example: String
    let synonyms: [String?]
    let antonyms: [String?]
}
