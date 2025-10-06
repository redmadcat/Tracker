//
//  ViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 04.09.2025.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureTabBarItems()
        configureTabBar()
    }
    
    private func configureTabBarItems() {
        let trackersViewController = TrackersViewController()
        let statsViewController = StatsViewController()
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        
        navigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackersNoActive"),
            selectedImage: nil
        )
        
        statsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatsNoActive"),
            selectedImage: nil
        )
        
        viewControllers = [navigationController, statsViewController]
    }
    
    private func configureTabBar() {
        tabBar.backgroundColor = .ypWhite
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
        tabBar.addBorder(to: .top, width: 0.5, color: .ypGray)
    }
}

#Preview {
    TabBarController()
}
