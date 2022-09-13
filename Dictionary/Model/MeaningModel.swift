//
//  MeaningModelk.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation

struct Meaning: Decodable {
    let partOfSpeech: String
    let definitions: [Definition?]
    let synonyms: [String?]
    let antonyms: [String?]
}
