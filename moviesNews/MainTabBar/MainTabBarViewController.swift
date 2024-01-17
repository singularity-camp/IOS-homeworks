//
//  MainTabBarViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 16.01.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: Properties
    private let titles: [String] = ["Home", "For You", "Favorites", "Find", "Profile"]
    private let icons: [UIImage?] = [
        UIImage(named: "icon_home"),
        UIImage(named: "icon_for_you"),
        UIImage(named: "icon_favorites"),
        UIImage(named: "icon_search"),
        UIImage(named: "icon_profile")
    ]
    
    private var allViewControllers = [
        UINavigationController(rootViewController: MainViewController()),
        ForYouViewController(),
        UINavigationController(rootViewController: FavoritesViewController()),
        SearchViewController(),
        ProfileViewController()
    ]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabBarViews()
    }
    
    // MARK: Methods
    private func makeTabBarViews(){
        view.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers(allViewControllers, animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        for i in 0..<items.count {
            items[i].title = titles[i]
            items[i].image = icons[i]
        }
    }
}
