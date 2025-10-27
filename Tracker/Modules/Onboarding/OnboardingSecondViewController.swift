//
//  OnboardingSecondViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 27.10.2025.
//

import UIKit

final class OnboardingSecondViewController: OnboardingViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private func
    private func configureUI() {
        // imageView
        imageView.image = UIImage(named: "OnboardingImage2")
        
        // label
        label.text = """
            Даже если это
            не литры воды и йога
            """
        label.textAlignment = .center
    }
}

@available(iOS 17.0, *)
#Preview {
    OnboardingSecondViewController()
}
