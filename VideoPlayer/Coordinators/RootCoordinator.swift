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
    private var mainViewController: MainViewController?
    private var videoPlayerViewController: VideoPlayerViewController?
    
    // MARK: - Init -
    
    init() {}
    
    func start() {
        showMainScreen()
    }
    
    // MARK: - Module methods -
    
    private func showMainScreen() {
        let mainViewController = MainViewController(delegate: self)
        self.mainViewController = mainViewController
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
    
    private func showVideoPlayer() {
        let videoPlayerViewController = VideoPlayerViewController(delegate: self)
        videoPlayerViewController.modalTransitionStyle = .crossDissolve
        videoPlayerViewController.modalPresentationStyle = .fullScreen
        
        mainViewController?.present(videoPlayerViewController, animated: true, completion: { [weak self] in
            self?.videoPlayerViewController = videoPlayerViewController
        })
    }
}

// MARK: - RootCoordinatorDelegate methods -

extension RootCoordinator: RootCoordinatorDelegate {
    func didTapOnPlayButton() {
        showVideoPlayer()
    }
}
