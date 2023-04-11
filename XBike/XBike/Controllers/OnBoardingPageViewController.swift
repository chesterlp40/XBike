//
//  OnBoardingPageViewController.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 10/04/2023.
//

import UIKit

class OnBoardingPageViewController: UIPageViewController {
    lazy var pages: [UIViewController] = {
        return [
            PageViewController(
                imageName: "easy",
                subTitle: "Extremely simple to use"
            ),
            PageViewController(
                imageName: "distance",
                subTitle: "Track your time and distance"
            ),
            PageViewController(
                imageName: "boastful",
                subTitle: "See your progress and challenge yourself!"
            )
        ]
    }()
    private let pageControl = UIPageControl()
    private let initialPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
    }
    
    private func setupComponents() {
        dataSource = self
        delegate = self
        
        self.navigationController?.setNavigationBarHidden(
            true,
            animated: false
        )
        self.pageControl.addTarget(
            self,
            action: #selector(pageControlTapped(_:)),
            for: .valueChanged
        )
        self.setViewControllers(
            [self.pages[self.initialPage]],
            direction: .forward,
            animated: true,
            completion: nil
        )
        self.setupPageControl()
        
    }
    
    private func setupPageControl() {
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.currentPageIndicatorTintColor = .black
        self.pageControl.pageIndicatorTintColor = .systemGray2
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = self.initialPage
        self.view.addSubview(self.pageControl)
        
        NSLayoutConstraint.activate([
            self.pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.pageControl.heightAnchor.constraint(equalToConstant: 20),
            self.view.bottomAnchor.constraint(
                equalToSystemSpacingBelow: self.pageControl.bottomAnchor,
                multiplier: 3
            ),
        ])
    }
    
    @objc
    func pageControlTapped(
        _ sender: UIPageControl
    ) {
        self.setViewControllers(
            [self.pages[sender.currentPage]],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - DataSources

extension OnBoardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let currentIndex = self.pages.firstIndex(of: viewController)
        else {
            return nil
        }
        
        if currentIndex == 0 {
            return self.pages.last
        } else {
            return self.pages[currentIndex - 1]
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let currentIndex = self.pages.firstIndex(of: viewController)
        else {
            return nil
        }

        if currentIndex < self.pages.count - 1 {
            return self.pages[currentIndex + 1]
        } else {
            return self.pages.first
        }
    }
}

// MARK: - Delegates

extension OnBoardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewControllers = pageViewController.viewControllers,
            let currentIndex = pages.firstIndex(of: viewControllers[0])
        else {
            return
        }
        self.pageControl.currentPage = currentIndex
    }
}
