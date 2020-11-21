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

        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addControlItemsView()
        setupVideoPlayer()
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
        print("Deinit VideoPlayerViewController")
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
}

extension VideoPlayerViewController: VideoControlItemsViewDelegate {
    func didTapOnCloseButton() {
        delegate?.didTapOnCloseButton()
    }
}
