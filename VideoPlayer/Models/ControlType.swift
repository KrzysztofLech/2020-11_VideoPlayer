//
//  ControlType.swift
//  VideoPlayer
//
//  Created by KL on 22/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit

enum ControlType {
    case close
    case pip
    case play
    case pause
    case back
    case forward
    
    var icon: UIImage? {
        switch self {
        case .close: return UIImage(named: "close_icon")
        case .pip: return UIImage(named: "pip_icon")
        case .play: return UIImage(named: "play_icon")
        case .pause: return UIImage(named: "pause_icon")
        case .back: return UIImage(named: "replay_icon")
        case .forward: return UIImage(named: "forward_icon")
        }
    }
}
