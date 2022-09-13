//
//  WordPagesViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 13/09/22.
//

import UIKit

class WordPagesViewController: UIPageViewController {
    
    // MARK: -> Properties
    
    private let pageController: UIPageControl = UIPageControl()
    public var initialIndex: Int?
    public var wordsContent: [String]?
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Before", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: -> LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Selectors
    
    @objc func nextTapped(_ sender: UIButton){
        pageController.currentPage += 1
        nextPage()
    }
    
    @objc func backTapped(_ sender: UIButton){
        pageController.currentPage -= 1
        backPage()
    }
    
    // MARK: -> Configure/Helpers
    
    func configureUI(){
        view.addSubview(pageController)
        dataSource = self
        delegate = self
        
        let page = WordDetailsViewController()
        page.word = wordsContent![initialIndex!]
        
        setViewControllers([page], direction: .forward, animated: true)
        backButton.isHidden = initialIndex == 0 ? true : false
        configurePageControllUI()
    }
    
    func configurePageControllUI() {
        pageController.anchor(bottom: view.bottomAnchor, paddingBottom: 20)
        pageController.centerX(inView: view)
        pageController.translatesAutoresizingMaskIntoConstraints = false
        pageController.currentPageIndicatorTintColor = UIColor(named: "Cyan")
        pageController.pageIndicatorTintColor = UIColor(named: "Neutral")?.withAlphaComponent(0.4)
        pageController.currentPage = initialIndex!
        view.addSubview(nextButton)
        view.addSubview(backButton)
        configureButtons()
    }
    
    func configureButtons(){
        nextButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 10, paddingRight: 20)
        backButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 20, paddingBottom: 10)
    }
    
    func nextPage(){
        let page = WordDetailsViewController()
        initialIndex! += 1
        page.word = wordsContent![initialIndex!]
        backButton.isHidden = false
        if initialIndex == wordsContent!.count - 1 {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        setViewControllers([page], direction: .forward, animated: true)
    }
    
    func backPage(){
        let page = WordDetailsViewController()
        initialIndex! -= 1
        page.word = wordsContent![initialIndex!]
        nextButton.isHidden = false
        if initialIndex == 0 {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
        setViewControllers([page], direction: .reverse, animated: true)
    }

}

// MARK: -> Extensions

extension WordPagesViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndexView = wordsContent!.firstIndex(of:(viewController as! WordDetailsViewController).word! as String) else { return nil }
        
        if currentIndexView == 0 {
            backButton.isHidden = true
            return nil
        } else {
            initialIndex! -= 1
            let page = WordDetailsViewController()
            page.word = wordsContent![initialIndex!]
            backButton.isHidden = false
            return page
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndexView = wordsContent!.firstIndex(of:(viewController as! WordDetailsViewController).word! as String) else { return nil }

        if currentIndexView < (wordsContent!.count - 1) {
            backButton.isHidden = false
            let page = WordDetailsViewController()
            initialIndex! += 1
            page.word = wordsContent![initialIndex!]
            return page
        } else {
            nextButton.isHidden = true
            return nil
        }

    }
}
