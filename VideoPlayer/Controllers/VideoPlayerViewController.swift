//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit
import AVKit

final class VideoPlayerViewController: UIViewController {
    
    private enum Constants {
        static let videoMoveTimeStepInSeconds: Double = 5
    }
    
    private weak var delegate: RootCoordinatorDelegate?
    
    private let previousSessionVideoTime: Double
    private let player: AVPlayer
    private let playerLayer: AVPlayerLayer
    private let viewModel: VideoPlayerViewModel
    
    private var pictureInPictureController: AVPictureInPictureController?
    private var isPipActive = false
    
    private var isStatusBarHidden: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    // MARK: - View objects -
    
    private lazy var controlItemsView: VideoControlItemsView = {
        let view = VideoControlItemsView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle -

    init(videoUrl: URL, previousSessionVideoTime: Double, delegate: RootCoordinatorDelegate) {
        self.previousSessionVideoTime = previousSessionVideoTime
        self.player = AVPlayer(url: videoUrl)
        self.playerLayer = AVPlayerLayer(player: player)
        self.viewModel = VideoPlayerViewModel(playerItem: player.currentItem)

        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    override var prefersStatusBarHidden: Bool { return isStatusBarHidden }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addControlItemsView()
        setupVideoPlayer()
        addTapGestureRecognizer()
        setupProgressObserver()
        addEndFileNotification()
        addMoveToBackgroundNotification()
        setupPictureInPicture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        moveVideoIfNeeded()
        player.play()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        playerLayer.frame = view.frame
    }

    // MARK: - Setup methods -
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func addControlItemsView() {
        view.addSubview(controlItemsView)
        controlItemsView.fillSuperview()
    }
        
    private func setupVideoPlayer() {
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspect
        view.layer.insertSublayer(playerLayer, below: controlItemsView.layer)
    }
    
    private func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func didTapOnView() {
        guard !isPipActive else { return }
        controlItemsView.manageVisibility()
    }
    
    // MARK: - Notifications -
    
    private func addEndFileNotification() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: nil) { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.controlItemsView.setPause()
        }
    }
    
    private func addMoveToBackgroundNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let playerCurrentTime = self?.player.currentTime() else { return }
        
            self?.player.pause()
            self?.controlItemsView.setPause()
            let playerCurrentTimeInSeconds = CMTimeGetSeconds(playerCurrentTime)
            self?.delegate?.saveCurrentPlayerTime(playerCurrentTimeInSeconds)
        }
    }
        
    // MARK: - Player methods -
    
    private func setupProgressObserver() {
        let interval = CMTimeMakeWithSeconds(0.1, preferredTimescale: 10)
        player.addPeriodicTimeObserver(forInterval: interval,
                                       queue: .main) { [weak self] time in
            
            guard let progressData = self?.viewModel.getProgressData(atTime: time) else { return }
            self?.controlItemsView.setProgress(progressData.value,
                                               time: progressData.time)
        }
    }
    
    private func moveVideo(forward: Bool) {
        let playerCurrentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        
        let newTime: Double = forward
            ? playerCurrentTimeInSeconds + Constants.videoMoveTimeStepInSeconds
            : playerCurrentTimeInSeconds - Constants.videoMoveTimeStepInSeconds
        
        if newTime < 0 {
            player.seek(to: .zero)
            player.pause()
            controlItemsView.setPause()
            
        } else if newTime < viewModel.durationInSeconds {
            let selectedTime = CMTime(seconds: newTime, preferredTimescale: 1000)
            player.seek(to: selectedTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    private func moveVideoIfNeeded() {
        guard previousSessionVideoTime > 0 else { return }
        
        let time = CMTime(seconds: previousSessionVideoTime, preferredTimescale: 1000)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    // MARK: - Picture In Picture methods -
    
    private func setupPictureInPicture() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)
            pictureInPictureController?.delegate = self
        } else {
            print("Picture in picture is not supported!")
        }
    }
    
    private func startPipMode() {
        pictureInPictureController?.startPictureInPicture()
        isPipActive = true
    }
}

extension VideoPlayerViewController: VideoControlItemsViewDelegate {
    func didTapOnButton(_ type: ControlType) {
        switch type {
        case .close: delegate?.didTapOnCloseButton()
        case .pip: startPipMode()
        case .play: player.play()
        case .pause: player.pause()
        case .back: moveVideo(forward: false)
        case .forward: moveVideo(forward: true)
        }
    }
    
    func hideStatusBar(_ hide: Bool) {
        isStatusBarHidden = hide
    }
}

extension VideoPlayerViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        controlItemsView.manageVisibility()
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        controlItemsView.setPipOff()
        isPipActive = false
    }
            
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}
