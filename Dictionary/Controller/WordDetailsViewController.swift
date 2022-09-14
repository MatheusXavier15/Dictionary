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
    var wordView = WordDetailView()
    private var wordInfo: Word?
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadWord()
    }
    // MARK: -> Selectors
    
    // MARK: -> Configure/Helpers
    
    func loadWord(){
        Services.shared.fetchWord(word!) { word, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let word = word {
                DispatchQueue.main.async {
                    self.wordView.word = word[0]
                    self.configureUI()
                }
            } else {
                DispatchQueue.main.async {
                    self.configureNotFound()
                }
            }
        }
    }
    
    func configureUI(){
        wordView.configureUI()
        self.view.addSubview(wordView)
        wordView.setDimensions(height: self.view.frame.height, width: self.view.frame.width)
        wordView.centerX(inView: self.view)
        wordView.centerY(inView: self.view)
    }
    
    func configureNotFound(){
        wordView.word = Word(word: word!)
        wordView.configureNotFound()
        self.view.addSubview(wordView)
        wordView.setDimensions(height: self.view.frame.height, width: self.view.frame.width)
        wordView.centerX(inView: self.view)
        wordView.centerY(inView: self.view)
    }
}
