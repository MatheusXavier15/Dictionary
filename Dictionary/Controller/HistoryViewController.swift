//
//  HistoryViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class HistoryViewController: UIViewController{

    // MARK: -> Properties
    
    var words: [WordHistory]?
    private let tableView = UITableView()
    private let reusableIdentifier = "HistoryTableViewCell"
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "History"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleDeleteAll))
        self.navigationItem.rightBarButtonItem = buttonItem
        self.words = try? HistoryDataModel.shared.fetchRegisters()
        self.configureTableView()
        self.tableView.reloadData()
    }
    
    // MARK: -> Selectors
    
    @objc func handleDeleteAll(){
        makeAlertDialog(title: "Delete all history?", message: "Do you want to delete all content in history?") {
            try? HistoryDataModel.shared.deleteAllRegisters()
            self.words = try? HistoryDataModel.shared.fetchRegisters()
            self.tableView.reloadData()
        }
    }
    
    // MARK: -> Configure/Helpers
    func configureUI(){
        self.view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 25)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: self.reusableIdentifier)
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        configureUI()
    }
    
    func makeAlertDialog(title: String, message: String, completion: @escaping() -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in
            completion()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            return
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.words?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! HistoryTableViewCell
        cell.word = words?[indexPath.row].word
        cell.state = words?[indexPath.row].favorite ?? false ? .fav : .normal
        cell.delegate = self
        return cell
    }
}

extension HistoryViewController: HistoryListDelegate {
    func handleDelete(word: String) {
        makeAlertDialog(title: "Delete \"\(word)\" from history?", message: "Do you want to delete the word \"\(word)\" from your history?") {
            try? HistoryDataModel.shared.deleteRegister(withWord: word)
            self.words = try? HistoryDataModel.shared.fetchRegisters()
            self.tableView.reloadData()
        }
    }
}
