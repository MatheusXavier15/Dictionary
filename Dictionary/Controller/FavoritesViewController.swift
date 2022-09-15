//
//  FavoritesViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: -> Properties
    
    var words: [FavoriteModel]?
    private let tableView = UITableView()
    private let reusableIdentifier = "FavoritesTableCell"
    
    private let noFavWords: UILabel =  {
       let lb = UILabel()
        lb.text = "No favorite words yet! \n Empty favorites word list"
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
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FavoritesDataModel().fetchFavorites { result in
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
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: self.reusableIdentifier)
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        configureUI()
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.words?.count == 0 {
            tableView.backgroundView = noFavWords
        } else {
            tableView.backgroundView = nil
        }
        return self.words?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! FavoritesTableViewCell
        cell.delegate = self
        cell.word = words?[indexPath.row]
        cell.state = .fav
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

extension FavoritesViewController: FavoriteWordListDelegate {
    func handleFavorite() {
        FavoritesDataModel().fetchFavorites { result in
            self.words = result
            self.tableView.reloadData()
        }
    }
}
