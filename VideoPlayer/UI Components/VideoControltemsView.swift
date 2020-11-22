//
//  VideoControlItemsView.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

protocol VideoControlItemsViewDelegate: AnyObject {
    func didTapOnButton(_ type: ControlType)
    func hideStatusBar(_ hide: Bool)
}

final class VideoControlItemsView: UIView {
    
    private enum Constants {
        static let dimDelay: Double = 0.5
        static let longDimDelay: Double = 1.5
        
        static let closeButtonSize = CGSize(width: 50, height: 50)
        static let controlItemSize = CGSize(width: 60, height: 60)
    }
        
    private weak var delegate: VideoControlItemsViewDelegate?
    
    private var isContentVisible = false
    
    private var isPlayerPaused = false {
        didSet { managePlayerState() }
    }
    
    private var dispatchWorkItem: DispatchWorkItem?
    
    // MARK: - UI control objects -
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        return VideoControlButton(type: .close) { [weak self] in
            self?.didTapOnCloseButton()
        }
    }()
    
    private lazy var playButton: UIButton = {
        return VideoControlButton(type: .play) { [weak self] in
            self?.didTapOnPlayButton()
        }
    }()
    
    private lazy var pauseButton: UIButton = {
        return VideoControlButton(type: .pause) { [weak self] in
            self?.didTapOnPauseButton()
        }
    }()
    
    private lazy var backButton: UIButton = {
        return VideoControlButton(type: .back) { [weak self] in
            self?.didTapOnBackButton()
        }
    }()
    
    private lazy var forwardButton: UIButton = {
        return VideoControlButton(type: .forward) { [weak self] in
            self?.didTapOnForwardButton()
        }
    }()
    
    private let progressBar: ProgressBar = {
        return ProgressBar()
    }()
    
    // MARK: - Lifecycle -
    init(delegate: VideoControlItemsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinit VideoControlItemsViewDelegate")   /// WYKASOWAć !!!
    }

    // MARK: - Setup methods -
    
    private func setup() {
        alpha = 0
        playButton.alpha = 0
        
        [dimView, closeButton, playButton, pauseButton, backButton, forwardButton, progressBar]
            .forEach { addSubview($0) }
        
        dimView.fillSuperview()
        closeButton.placeAtTopLeftSuperviewCorner(withSize: Constants.closeButtonSize)
        playButton.centerInSuperView(withSize: Constants.controlItemSize)
        pauseButton.centerInSuperView(withSize: Constants.controlItemSize)
        backButton.centerInSuperView(withSize: Constants.controlItemSize, offset: CGPoint(x: -80, y: 0))
        forwardButton.centerInSuperView(withSize: Constants.controlItemSize, offset: CGPoint(x: 80, y: 0))
        progressBar.placeAtSuperviewBottom()
    }

    private func hideContent(hide: Bool, withDelay delay: Double = 0) {
        dispatchWorkItem?.cancel()
        dispatchWorkItem = DispatchWorkItem { [weak self] in
            self?.isContentVisible = !hide
            UIView.animate(withDuration: 0.3) {
                self?.alpha = hide ? 0 : 1
            }
        }
        
        if let dispatchWorkItem = dispatchWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: dispatchWorkItem)
        }
    }
    
    private func managePlayerState() {
        if isPlayerPaused {
            UIView.animate(withDuration: 0.3) {
                self.pauseButton.alpha = 0
            } completion: { _ in
                self.delegate?.hideStatusBar(true)
            }
            UIView.animate(withDuration: 0.3, delay: Constants.dimDelay + 0.15) {
                self.playButton.alpha = 1
            }
            
        } else {
            UIView.animate(withDuration: 0.3) {
                self.playButton.alpha = 0
            } completion: { _ in
                self.delegate?.hideStatusBar(true)
            }
            UIView.animate(withDuration: 0.3, delay: Constants.dimDelay + 0.15) {
                self.pauseButton.alpha = 1
            }
        }
        
        hideContent(hide: true, withDelay: Constants.dimDelay)
    }
    
    // MARK: - Action methods -
    
    private func didTapOnCloseButton() {
        delegate?.didTapOnButton(.close)
    }
    
    private func didTapOnPlayButton() {
        isPlayerPaused = false
        delegate?.didTapOnButton(.play)
    }

    private func didTapOnPauseButton() {
        isPlayerPaused = true
        delegate?.didTapOnButton(.pause)
    }
    
    private func didTapOnBackButton() {
        delegate?.didTapOnButton(.back)
        hideContent(hide: true, withDelay: Constants.longDimDelay)
    }

    private func didTapOnForwardButton() {
        delegate?.didTapOnButton(.forward)
        hideContent(hide: true, withDelay: Constants.longDimDelay)
    }
    
    // MARK: - public methods -
    
    func manageVisibility() {
        hideContent(hide: isContentVisible)
        delegate?.hideStatusBar(isContentVisible)
    }
    
    func setProgress(_ value: Float, time: String) {
        progressBar.setProgress(value, animated: false)
        progressBar.time = time
    }
    
    func resetState() {
        isPlayerPaused = true
    }
}
