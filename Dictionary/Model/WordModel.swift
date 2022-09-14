//
//  WordModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation

import Foundation

// MARK: - WordElement
struct Word: Decodable {
    let word, phonetic: String?
    let phonetics: [Phonetic]?
    let meanings: [Meaning]?
    let license: License?
    let sourceUrls: [String]?
    
    init(word: String){
        self.word = word
        self.phonetic = nil
        self.phonetics = nil
        self.meanings = nil
        self.license = nil
        self.sourceUrls = nil
    }
}

// MARK: - License
struct License: Decodable {
    let name: String?
    let url: String?
}

// MARK: - Meaning
struct Meaning: Decodable {
    let partOfSpeech: String?
    let definitions: [Definition]?
    let synonyms, antonyms: [String?]?
}

// MARK: - Definition
struct Definition: Decodable {
    let definition: String?
    let synonyms, antonyms: [String?]?
    let example: String?
}

// MARK: - Phonetic
struct Phonetic: Decodable {
    let text: String?
    let audio: String?
    let sourceURL: String?
}
