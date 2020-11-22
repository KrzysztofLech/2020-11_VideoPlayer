//
//  SettingsService.swift
//  VideoPlayer
//
//  Created by KL on 22/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import Foundation

enum SettingsKey {
    static let videoTime = "videoTime"
}

protocol SettingsServiceProtocol {
    var previousSessionVideoTime: Double { get set }
}

final class SettingsService: SettingsServiceProtocol {
    
    private func write(object: Any, forKey key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func getObject(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
        
    // MARK: - Protocol properties -

    var previousSessionVideoTime: Double {
        get {
            return getObject(forKey: SettingsKey.videoTime) as? Double ?? 0
        }
        set {
            write(object: newValue, forKey: SettingsKey.videoTime)
        }
    }
}
