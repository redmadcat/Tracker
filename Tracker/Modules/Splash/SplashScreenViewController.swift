//
//  SplashScreenViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 27.10.2025.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    // MARK: - Definition
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    private lazy var imageView = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
        configureLayout()
        configureStartUp()
    }
    
    // MARK: - Private func
    private func configureUI() {
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SplashScreenLogo")
        
        view.backgroundColor = .ypBlue
        
        // hierarchy
        view.addSubview(imageView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureStartUp() {
        let viewController = UserDefaultsService.shared.isSkipFutherCompleted ?
            TabBarController() :
            OnboardingPageViewController()
        goTo(viewController)
    }
    
    private func goTo(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}

@available(iOS 17.0, *)
#Preview {
    SplashScreenViewController()
}
