//
//  VideoPlayerViewModel.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import AVFoundation

final class VideoPlayerViewModel {
    
    private let playerItem: AVPlayerItem?
    
    private var duration: CMTime {
        return playerItem?.duration ?? .zero
    }
    
    var durationInSeconds: Double {
        return CMTimeGetSeconds(duration)
    }
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()

    
    init(playerItem: AVPlayerItem?) {
        self.playerItem = playerItem
    }
    
    func getProgressData(atTime time: CMTime) -> (value: Float, time: String) {
        let currentTimeInSeconds = CMTimeGetSeconds(time)
        
        guard currentTimeInSeconds >= 0, durationInSeconds > 0,
              let currentTimeString = createTimeString(time: currentTimeInSeconds),
              let durationTimeString = createTimeString(time: durationInSeconds)
        else { return (0, "") }

        let value = Float(currentTimeInSeconds / durationInSeconds)
        let time = String(format: "%@ / %@", currentTimeString, durationTimeString)

        return (value, time)
    }
    
    private func createTimeString(time: Double) -> String? {
        let components = NSDateComponents()
        components.second = Int(time)
        return timeFormatter.string(from: components as DateComponents)
    }
}
