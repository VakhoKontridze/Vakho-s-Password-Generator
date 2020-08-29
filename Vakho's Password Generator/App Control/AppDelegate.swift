//
//  AppDelegate.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Cocoa
import SwiftUI

// MARK: App Delegate
/*@NSApplicationMain*/ class AppDelegate: NSObject {}

// MARK:- App Delegate
extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //MainFactory.shared.createWindow()
        
        RandomGenerator(settings: .init()).generate()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
