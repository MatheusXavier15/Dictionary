//
//  WordDetailsViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class WordDetailsViewController: UIViewController {
    
    // MARK: -> Properties
    var word: String?
    private var wordInfo: Word?
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWord()
        self.configureUI()
    }
    // MARK: -> Selectors
    
    // MARK: -> Configure/Helpers
    
    func loadWord(){
        Services.shared.fetchWord(word!) { word, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func configureUI(){

        view.backgroundColor = .systemGray6

    }
    
}
