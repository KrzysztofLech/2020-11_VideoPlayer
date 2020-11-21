//
//  VideoControlItemsView.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

enum ControlType {
    case close
    case play
    case pause
    
    var icon: UIImage? {
        switch self {
        case .close: return UIImage(named: "close_icon")
        case .play: return UIImage(named: "play_icon")
        case .pause: return UIImage(named: "pause_icon")
        }
    }
}

protocol VideoControlItemsViewDelegate: AnyObject {
    func didTapOnButton(_ type: ControlType)
}

final class VideoControlItemsView: UIView {
    
    private enum Constants {
        static let closeButtonSize = CGSize(width: 50, height: 50)
        static let controlItemSize = CGSize(width: 60, height: 60)
    }
        
    private weak var delegate: VideoControlItemsViewDelegate?
    
    private var isPlayerPaused = false
    
    // MARK: - Control objects -
    
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
    
    // MARK: - Lifecycle -
    init(delegate: VideoControlItemsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods -
    
    private func setup() {
        playButton.isHidden = !isPlayerPaused
        
        [dimView, closeButton, playButton, pauseButton]
            .forEach { addSubview($0) }
        
        dimView.fillSuperview()
        closeButton.placeAtTopLeftSuperviewCorner(withSize: Constants.closeButtonSize)
        playButton.centerInSuperView(withSize: Constants.controlItemSize)
        pauseButton.centerInSuperView(withSize: Constants.controlItemSize)
    }
    
    // MARK: - Action methods -
    
    private func didTapOnCloseButton() {
        delegate?.didTapOnButton(.close)
    }
    
    private func didTapOnPlayButton() {
        delegate?.didTapOnButton(.play)
    }

    private func didTapOnPauseButton() {
        delegate?.didTapOnButton(.pause)
    }
}
