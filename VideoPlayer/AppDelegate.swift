//
//  AppDelegate.swift
//  VideoPlayer
//
//  Created by KL on 21/11/2020.
//  Copyright © 2020 KL. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootCoordinator: RootCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Unable to set audio session category!")
        }
        
        rootCoordinator = RootCoordinator()
        rootCoordinator?.start()

        return true
    }
}
