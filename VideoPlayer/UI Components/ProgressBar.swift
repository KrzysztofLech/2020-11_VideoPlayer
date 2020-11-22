//
//  ProgressBar.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

class ProgressBar: UIProgressView {
    
    var time: String = "" {
        didSet {
            label.text = time
        }
    }
        
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 125/255, green: 195/255, blue: 203/255, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        tintColor = UIColor(red: 0/255, green: 91/255, blue: 104/255, alpha: 1)
        progressViewStyle = .bar
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: topAnchor, constant: -2)
        ])
    }
}

