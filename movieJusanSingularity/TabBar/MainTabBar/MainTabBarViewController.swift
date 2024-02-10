//
//  MainTabBarViewController.swift
//  movieJusanSingularity
//
//  Created by Mariya Aliyeva on 13.01.2024.
//

import UIKit
import SwiftKeychainWrapper

final class MainTabBarViewController: UITabBarController {
	
	// MARK: - Private properties
	var isLogin = false
	private let titles: [String] = ["Home", "For you", "Favorites", "Find", "Profile"]
	
	private let icons: [UIImage?] = [
		UIImage(named: "icon_home"),
		UIImage(named: "star_icon"),
		UIImage(named: "heart"),
		UIImage(named: "icon_find"),
		UIImage(named: "icon_profile")
	]
	
	
	private var allViewController = [
		UINavigationController(rootViewController: MainViewController()),
		ForYouViewController(),
		UINavigationController(rootViewController: FavoriteViewController()),
		SearchViewController(),
		UINavigationController(rootViewController: LoginViewController()),
	]
	
	private var allViewController1 = [
		UINavigationController(rootViewController: MainViewController()),
		ForYouViewController(),
		UINavigationController(rootViewController: FavoriteViewController()),
		SearchViewController(),
		ProfileViewController()
	]
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		isLogin = false
		makeTabBarViews()
	}

	// MARK: - Private methods
	private func makeTabBarViews() {
		isLogin = UserDefaults.standard.bool(forKey: "isLogin")
		view.backgroundColor = .systemGray
		tabBar.tintColor = .black
		tabBar.backgroundColor = .white
		
		if isLogin == true {
			setViewControllers(allViewController1, animated: false)
		} else {
			setViewControllers(allViewController, animated: false)
		}
	
		guard let items = self.tabBar.items else {return}
		
		for i in 0..<items.count {
			items[i].title = titles[i]
			items[i].image = icons[i]
		}
	}
}
