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
/*@NSApplicationMain*/ class AppDelegate: NSObject {
    private let passwordSettings: SettingsViewModel = .init()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = .init(name: "Vakho_s_Password_Generator")

        container.persistentStoreDescriptions.append({
            let description: NSPersistentStoreDescription = .init()
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            return description
        }())
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext { persistentContainer.viewContext }
}

// MARK:- App Delegate
extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        PasswordGeneratorController.shared.settings = passwordSettings
        PasswordGeneratorController.shared.managedObjectContext = managedObjectContext
        
        MainFactory.shared.createWindow(managedObjectContext: managedObjectContext, settings: passwordSettings)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

// MARK: App Name
extension AppDelegate {
    static var appName: String? {
        Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
}

// MARK:- Core Data
extension AppDelegate {
    @IBAction func saveAction(_ sender: AnyObject?) -> Void {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSApp.presentError(error)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? { managedObjectContext.undoManager }
}
