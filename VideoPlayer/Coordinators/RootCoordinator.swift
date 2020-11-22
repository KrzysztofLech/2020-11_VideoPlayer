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
    func saveCurrentPlayerTime(_ time: Double)
}

final class RootCoordinator: Coordinator {
    
    private enum Constants {
        static let testVideoUrl = "https://bit.ly/2ZKwDrA"
    }
    
    // MARK: - Properties -
    
    private var settingsService: SettingsServiceProtocol
    private var window: UIWindow?
    private var mainViewController: MainViewController?
    private var videoPlayerViewController: VideoPlayerViewController?
    
    // MARK: - Init -
    
    init() {
        self.settingsService = SettingsService()
    }
    
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
        let previousTime = settingsService.previousSessionVideoTime
        if previousTime > 0 {
            presentVideoController(previousSessionVideoTime: previousTime)
        } else {
            presentVideoController(previousSessionVideoTime: 0)
        }
    }
    
    private func presentVideoController(previousSessionVideoTime: Double) {
        guard let url = URL(string: Constants.testVideoUrl) else { return }
        
        let videoPlayerViewController = VideoPlayerViewController(
            videoUrl: url,
            previousSessionVideoTime: previousSessionVideoTime,
            delegate: self)
        videoPlayerViewController.modalTransitionStyle = .crossDissolve
        videoPlayerViewController.modalPresentationStyle = .fullScreen
        
        mainViewController?.present(videoPlayerViewController, animated: true, completion: { [weak self] in
            self?.videoPlayerViewController = videoPlayerViewController
            self?.removePreviousSessionVideoTime()
        })
    }
    
    private func hideVideoPlayer() {
        videoPlayerViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.videoPlayerViewController = nil
        })
    }
    
    private func removePreviousSessionVideoTime() {
        settingsService.previousSessionVideoTime = 0
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
    
    func saveCurrentPlayerTime(_ time: Double) {
        settingsService.previousSessionVideoTime = time
    }
}
