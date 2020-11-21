//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

final class VideoPlayerViewController: UIViewController {
    
    private weak var delegate: RootCoordinatorDelegate?
    
    // MARK: - View objects -
    
    
    // MARK: - Lifecycle -

    init(delegate: RootCoordinatorDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Setup methods -
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    // MARK: - Action methods -
    
}
