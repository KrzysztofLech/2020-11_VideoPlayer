//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

final class VideoPlayerViewController: UIViewController {
    
    private enum Constants {
        static let closeButtonSize = CGSize(width: 50, height: 50)
    }

    
    private weak var delegate: RootCoordinatorDelegate?
    
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
    
    // MARK: - Action methods -
    
    @objc private func didTapOnCloseButton() {
        delegate?.didTapOnCloseButton()
    }
}
