//
//  MainViewController.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    private enum Constants {
        static let playButtonSize = CGSize(width: 100, height: 100)
    }
    
    private weak var delegate: RootCoordinatorDelegate?
    
    // MARK: - View objects -
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(red: 215/255, green: 180/255, blue: 16/255, alpha: 1)
        button.addTarget(self, action: #selector(didTapOnPlayButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle -

    init(delegate: RootCoordinatorDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Setup methods -
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 0/255, green: 91/255, blue: 104/255, alpha: 1)
        
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: Constants.playButtonSize.width),
            playButton.heightAnchor.constraint(equalToConstant: Constants.playButtonSize.height)
        ])
    }
    
    // MARK: - Action methods -
    
    @objc private func didTapOnPlayButton() {
        delegate?.didTapOnPlayButton()
    }
}
