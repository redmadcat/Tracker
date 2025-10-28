//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 27.10.2025.
//

import UIKit

class OnboardingViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
            
    // MARK: - Actions
    @objc func doneButtonTapped() {
        UserDefaults.standard.setValue(true, forKey: "skipFurther")
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
}
