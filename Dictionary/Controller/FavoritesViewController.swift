//
//  FavoritesViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: -> Properties
    
    var words: [Favorite]?
    private let tableView = UITableView()
    private let reusableIdentifier = "FavoritesTableCell"
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.words = try? FavoritesDataModel.shared.fetchRegisters()
        self.configureTableView()
        self.tableView.reloadData()
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
        return self.words?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! FavoritesTableViewCell
        cell.delegate = self
        cell.word = words?[indexPath.row].word
        cell.state = .fav
        return cell
    }
}

extension FavoritesViewController: FavoriteWordListDelegate {
    func handleFavorite() {
        self.words = try? FavoritesDataModel.shared.fetchRegisters()
        self.tableView.reloadData()
    }
}
