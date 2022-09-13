//
//  PhoneticModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation

struct Phonetic: Decodable {
    let text: String
    let audio: String?
    let sourceURL: String
    let license: License
}
