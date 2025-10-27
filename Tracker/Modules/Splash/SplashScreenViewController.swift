//
//  SplashScreenViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 27.10.2025.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SplashScreenLogo")
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
        configureLayout()
        
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
    
    // MARK: - Private func
    private func configureUI() {
        view.backgroundColor = .ypBlue
        
        // hierarchy
        view.addSubview(logoImageView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
