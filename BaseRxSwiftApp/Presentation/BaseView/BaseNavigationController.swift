//
//  BaseNavigationController.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 25/8/25.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Default style for navigation bar
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .black
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        // Enable interactive pop gesture
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // Pass status bar style to top view controller
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow swipe back only if not the root view controller
        return viewControllers.count > 1
    }
}
