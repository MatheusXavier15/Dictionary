//
//  WordList.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation

class WordListDataModel {
    let words: [String]
    
    init(){
        let fileUrl = Bundle.main.url(forResource: "english", withExtension: "txt")!
        let data = try! Data(contentsOf: fileUrl)
        let str = String(decoding: data, as: UTF8.self)
        self.words = str.components(separatedBy: "\n")
    }
}
