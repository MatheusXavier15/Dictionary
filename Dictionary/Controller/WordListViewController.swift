//
//  WordListViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class WordListViewController: UIViewController {
    
    // MARK: -> Properties
    
    let wordList = WordListDataModel()
    private let tableView = UITableView()
    private let reusableIdentifier = "WordListTableCell"
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    
    // MARK: -> Selectors
    
    // MARK: -> Configure/Helpers
    
    func configureUI(){
        view.backgroundColor = .systemGray6
        navigationItem.title = "Word List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 25)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WordListTableViewCell.self, forCellReuseIdentifier: self.reusableIdentifier)
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        configureUI()
    }

}

extension WordListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordList.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! WordListTableViewCell
        cell.word = wordList.words[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordPages = WordPagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        wordPages.initialIndex = indexPath.row
        wordPages.wordsContent = wordList.words
        navigationController?.pushViewController(wordPages, animated: true)
        return
    }
}
