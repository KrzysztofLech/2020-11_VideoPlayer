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
    
    private enum Constants {
        static let closeButtonSize = CGSize(width: 50, height: 50)
    }
    
    private weak var delegate: RootCoordinatorDelegate?
    
    private let player: AVPlayer
    private let playerLayer: AVPlayerLayer
    
    // MARK: - View objects -
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapOnCloseButton), for: .touchUpInside)
        return button
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
        addCloseButton()
    }
    
    private func addCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize.width),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize.height)
        ])
    }
    
    private func setupVideoPlayer() {
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspect
        view.layer.insertSublayer(playerLayer, below: closeButton.layer)
    }
    
    // MARK: - Action methods -
    
    @objc private func didTapOnCloseButton() {
        delegate?.didTapOnCloseButton()
    }
}
