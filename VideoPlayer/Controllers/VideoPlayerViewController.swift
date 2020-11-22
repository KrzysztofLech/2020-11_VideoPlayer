//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit
import AVFoundation

final class VideoPlayerViewController: UIViewController {
    
    private weak var delegate: RootCoordinatorDelegate?
    
    private let player: AVPlayer
    private let playerLayer: AVPlayerLayer
    private let viewModel: VideoPlayerViewModel
    
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

    init(videoUrl: URL, delegate: RootCoordinatorDelegate) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player.play()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        playerLayer.frame = view.frame
    }
    
    deinit {
        print("Deinit VideoPlayerViewController")   /// WYKASOWAć !!!
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
        controlItemsView.manageVisibility()
    }
    
    private func setupProgressObserver() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval,
                                       queue: .main) { [weak self] time in
            
            guard let progressData = self?.viewModel.getProgressData(atTime: time) else { return }
            self?.controlItemsView.setProgress(progressData.value,
                                               time: progressData.time)
        }
    }
    
    private func addEndFileNotification() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: nil) { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.controlItemsView.resetState()
        }
    }
}

extension VideoPlayerViewController: VideoControlItemsViewDelegate {
    func didTapOnButton(_ type: ControlType) {
        switch type {
        case .close: delegate?.didTapOnCloseButton()
            
        case .play:
            player.play()
            
        case .pause:
            player.pause()
        }
    }
    
    func hideStatusBar(_ hide: Bool) {
        isStatusBarHidden = hide
    }
}
