//
//  ViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 04.09.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItems()
        configureTabBar()
    }
    
    private func configureTabBarItems() {
        let dataProvider = TrackerDataProvider(TrackerCategoryStore(), TrackerStore(), TrackerRecordStore(),
                                               with: DomainDataLayer.shared.context)
        let trackersViewController = TrackersViewController()
        trackersViewController.dataProvider = dataProvider
        let statsViewController = StatsViewController()
        statsViewController.recordStore = TrackerRecordStore()
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

@available(iOS 17.0, *)
#Preview {
    TabBarController()
}
