//
//  GithubTabBarController.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import UIKit

final class GithubTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [makeSearchViewController()]
    }
    
    private func makeSearchViewController() -> UINavigationController {
        let viewController = SearchViewController()
        viewController.tabBarItem = .init(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: viewController)
    }
}
