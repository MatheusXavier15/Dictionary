//
//  WordModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation

struct Word: Decodable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]
    let meanings: [Meaning]
    let license: License
    let sourceUrls: [String]?
}
