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
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "trackers",
            image: UIImage(named: "TrackersNoActive"),
            selectedImage: nil
        )
        
        statsViewController.tabBarItem = UITabBarItem(
            title: "stats",
            image: UIImage(named: "StatsNoActive"),
            selectedImage: nil
        )
        
        viewControllers = [trackersViewController, statsViewController]
    }
    
    private func configureTabBar() {
        tabBar.backgroundColor = .ypWhite
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
        tabBar.addBorder(to: .top, width: 0.5, color: .ypGray)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TabBarControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            TabBarController().toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
