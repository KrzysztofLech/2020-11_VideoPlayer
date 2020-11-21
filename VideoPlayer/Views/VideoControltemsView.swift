//
//  VideoControlItemsView.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

protocol VideoControlItemsViewDelegate: AnyObject {
    func didTapOnCloseButton()
}

final class VideoControlItemsView: UIView {
    
    private enum Constants {
        static let closeButtonSize = CGSize(width: 50, height: 50)
    }
        
    private weak var delegate: VideoControlItemsViewDelegate?
    
    // MARK: - Control objects -
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapOnCloseButton), for: .touchUpInside)
        return button
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
        addDimView()
        addCloseButton()
    }
    
    private func addDimView() {
        addSubview(dimView)
        dimView.fillSuperview()
    }
    
    private func addCloseButton() {
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize.width),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize.height)
        ])
    }

    // MARK: - Action methods -
    
    @objc internal func didTapOnCloseButton() {
        delegate?.didTapOnCloseButton()
    }
}
