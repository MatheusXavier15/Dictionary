//
//  HistoryViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class HistoryViewController: UIViewController{

    // MARK: -> Properties
    
    var words: [HistoryModel]?
    private let tableView = UITableView()
    private let reusableIdentifier = "HistoryTableViewCell"
    
    private let noHistoryWords: UILabel =  {
       let lb = UILabel()
        lb.text = "No words in history yet! \n Empty history word list"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.textColor = .black
        return lb
    }()
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "History"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HistoryDataModel().fetchRegisters { result in
            self.words = result
            self.configureTableView()
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
        if self.words?.count == 0 {
            tableView.backgroundView = noHistoryWords
        } else {
            tableView.backgroundView = nil
        }
        return self.words?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! HistoryTableViewCell
        let word = words?[indexPath.row]
        cell.word = word
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = words?[indexPath.row].word
        let wordView = WordDetailsViewController()
        wordView.word = word
        navigationController?.pushViewController(wordView, animated: true)
        return
    }
}

extension HistoryViewController: HistoryListDelegate {
    func handleDelete(word: HistoryModel) {
        makeAlertDialog(title: "Delete \"\(word.word)\" from history?", message: "Do you want to delete the word \"\(word.word)\" from your history?") {
            HistoryDataModel().deleteRegister(id: word.id!)
            HistoryDataModel().fetchRegisters { result in
                self.words = result
                self.tableView.reloadData()
            }
        }
    }
}
