//
//  OnboardingFirstViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 27.10.2025.
//

import UIKit

final class OnboardingFirstViewController: OnboardingViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private func
    private func configureUI() {
        // imageView
        imageView.image = UIImage(named: "OnboardingImage1")
        
        // label
        label.text = """
            Отслеживайте только 
            то, что хотите
            """
        label.textAlignment = .center
    }
}

@available(iOS 17.0, *)
#Preview {
    OnboardingFirstViewController()
}
