//
//  LibManager.swift
//  JikanDemo
//
//  Created by ice on 2022/4/10.
//

import Foundation
import CocoaLumberjackSwift
import IQKeyboardManagerSwift
import FirebaseCrashlytics
import Firebase

class LibsManager: NSObject {

    /// The default singleton instance.
    static let shared = LibsManager()

    private override init() {
        super.init()

        _ = UserConfigs.shared
    }

    func setupLibs() {
        let libsManager = LibsManager.shared
        libsManager.setupCocoaLumberjack()
        libsManager.setupAnalytics()
        libsManager.setupKeyboardManager()
    }

    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
    func setupCocoaLumberjack() {
        logInitail()
    }

    func setupAnalytics() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
    }
}
