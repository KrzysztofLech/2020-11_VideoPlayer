//
//  RootCoordinator.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

protocol RootCoordinatorDelegate: AnyObject {
    func didTapOnPlayButton()
}

final class RootCoordinator: Coordinator {
    
    // MARK: - Properties -
    
    private var window: UIWindow?
    private var navigationController: MainNavigationController?
    
    // MARK: - Init -
    
    init() {}
    
    func start() {
        showMainScreen()
    }
    
    // MARK: - Module methods -
    
    private func showMainScreen() {
        let mainViewController = MainViewController(delegate: self)
        let navigationController = MainNavigationController(rootViewController: mainViewController)
        self.navigationController = navigationController
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - RootCoordinatorDelegate methods -

extension RootCoordinator: RootCoordinatorDelegate {
    func didTapOnPlayButton() {
        print("didTapOnPlayButton")
    }
}
