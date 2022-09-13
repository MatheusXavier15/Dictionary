//
//  TabBarViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewControllers()
    }
    
    func configureViewControllers(){
        let wordlist = templateNavigationController(image: UIImage(systemName: "text.bubble"), title: "Word List", rootViewController: WordListViewController())
        let history = templateNavigationController(image: UIImage(systemName: "clock"), title: "History", rootViewController: HistoryViewController())
        let favorites = templateNavigationController(image: UIImage(systemName: "heart"), title: "Favorites", rootViewController: FavoritesViewController())
        self.viewControllers = [wordlist, history, favorites]
    }
    
    func templateNavigationController(image: UIImage? = nil, title: String? = nil, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        let navbarAppearance = UINavigationBarAppearance()
        navbarAppearance.configureWithTransparentBackground()
        navbarAppearance.backgroundColor = .systemGray6
        nav.navigationBar.standardAppearance = navbarAppearance
        nav.navigationBar.scrollEdgeAppearance = navbarAppearance
        return nav
    }
}
