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
    func didTapOnCloseButton()
}

final class RootCoordinator: Coordinator {
    
    private enum Constants {
        static let testVideoUrl = "https://bit.ly/2ZKwDrA"
    }
    
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
        guard let url = URL(string: Constants.testVideoUrl) else { return }
        
        let videoPlayerViewController = VideoPlayerViewController(videoUrl: url, delegate: self)
        videoPlayerViewController.modalTransitionStyle = .crossDissolve
        videoPlayerViewController.modalPresentationStyle = .fullScreen
        
        mainViewController?.present(videoPlayerViewController, animated: true, completion: { [weak self] in
            self?.videoPlayerViewController = videoPlayerViewController
        })
    }
    
    private func hideVideoPlayer() {
        videoPlayerViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.videoPlayerViewController = nil
        })
    }
}

// MARK: - RootCoordinatorDelegate methods -

extension RootCoordinator: RootCoordinatorDelegate {
    func didTapOnPlayButton() {
        showVideoPlayer()
    }
    
    func didTapOnCloseButton() {
        hideVideoPlayer()
    }
}
