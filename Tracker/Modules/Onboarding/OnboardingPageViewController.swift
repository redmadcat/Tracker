//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 27.10.2025.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // MARK: - Definition
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    private lazy var pageControl = UIPageControl()
    private lazy var onboardingPages: [UIViewController] =
        [OnboardingFirstViewController(), OnboardingSecondViewController()]
                    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
        
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private func
    private func configureUI() {
        dataSource = self
        delegate = self
        
        if let initialPage = onboardingPages.first {
            setViewControllers([initialPage], direction: .forward, animated: true, completion: nil)
        }
        
        // pageControl
        pageControl.numberOfPages = onboardingPages.count
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        // hierarchy
        view.addSubview(pageControl)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = onboardingPages.firstIndex(of: viewController), pageIndex > 0 else { return nil }
        return onboardingPages[pageIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = onboardingPages.firstIndex(of: viewController), pageIndex < (onboardingPages.count - 1) else { return nil }
        return onboardingPages[pageIndex + 1]
    }
            
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentPage = onboardingPages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentPage
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    OnboardingPageViewController()
}
