//
//  MainFactory.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Main Factory
final class MainFactory: NSObject {
    // MARK: Properties
    static let shared: MainFactory = .init()
    
    private var window: NSWindow!
    private var controller: NSWindowController!

    // MARK: Initializers
    private override init() {
        super.init()
    }
}

// MARK:- Window
extension MainFactory {
    func createWindow(managedObjectContext: NSManagedObjectContext, settings: SettingsViewModel) {
        // If window exists, brings it to front
        guard window == nil else {
            window.makeKeyAndOrderFront(nil)
            return
        }

        // Creates window
        window = .init(
            contentRect: .init(origin: .zero, size: MainView.ViewModel.window),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        window.center()
        window.makeKeyAndOrderFront(nil)

        // Customizes title bar
        window.titlebarAppearsTransparent = true

        window.title = AppDelegate.appName

        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isEnabled = false

        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isEnabled = false
        
        // Creates view
        window.contentView = NSHostingView(rootView:
            MainView()
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(settings)
        )
        
        // Creates window controller
        controller = .init(window: window)
        
        // Sets delegate
        window.delegate = self
    }
}

// MARK:- Delegate
extension MainFactory: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        guard notification.object as? NSWindow == window else { return }
        
        self.window = nil
        self.controller = nil
    }
}
