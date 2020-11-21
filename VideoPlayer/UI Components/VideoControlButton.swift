//
//  VideoControlButton.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

class VideoControlButton: UIButton {
    
    let type: ControlType
    private let action: ()->()
    
    init(type: ControlType, action: @escaping ()->()) {
        self.type = type
        self.action = action
        
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setImage(type.icon, for: .normal)
        tintColor = .white
        addTarget(nil, action: #selector(didTapOnButton), for: .touchUpInside)
    }
    
    @objc private func didTapOnButton() {
        action()
    }
}
