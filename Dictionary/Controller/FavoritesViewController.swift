//
//  FavoritesViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: -> Properties
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    // MARK: -> Selectors
    
    // MARK: -> Configure/Helpers
    func configureUI(){
        view.backgroundColor = .systemGray6
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
