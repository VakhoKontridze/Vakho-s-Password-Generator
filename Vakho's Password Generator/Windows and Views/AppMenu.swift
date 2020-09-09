//
//  MainMenu.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 9/9/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Cocoa

// MARK:- App Menu
final class AppMenu: NSMenu {
    // MARK: Properties
    private var passwordSettings: SettingsViewModel!
    
    
    // MARK: Initializers
    override init(title: String) {
        super.init(title: title)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init(settings: SettingsViewModel) {
        self.init(title: "Default")
        self.passwordSettings = settings
    }
    
    private func commonInit() {
        items = [
            createMainMenu(),
            createGenerateMenu(),
            createEditMenu(),
            createViewMenu(),
            createWindowMenu(),
            createHelpMenu()
        ]
    }
}

// MARK:- Sub Items
private extension AppMenu {
    func createMainMenu() -> NSMenuItem {
        let menu: NSMenuItem = .init()
        
        menu.submenu = .init(title: "MainMenu")
        menu.submenu?.items = [
            .init(title: "About \(AppDelegate.appName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""),
            
            .separator(),
            
//            .init(title: "Preferences...", action: nil, keyEquivalent: ","),

//            .separator(),
            
            .init(title: "Hide \(AppDelegate.appName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"),
            .init(title: "Hide Others", key: "h", modifier: [.command, .option], action: #selector(NSApplication.hideOtherApplications(_:))),
//            .init(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: ""),
            
            .separator(),
            
            .init(title: "Quit \(AppDelegate.appName)", action: #selector(NSApplication.shared.terminate(_:)), keyEquivalent: "q")
        ]
        
        return menu
    }
    
    func createGenerateMenu() -> NSMenuItem {
        let menu: NSMenuItem = .init()
        
        menu.submenu = .init(title: "Generate")
        menu.submenu?.items = [
            .init(in: self, title: "Generate", action: #selector(generate)),
            
            .separator(),
            
            .init(title: "Password Type", subItems: [
                .init(in: self, title: "Randomized", action: #selector(changePasswordTypeToRandomized)),
                .init(in: self, title: "Verbal", action: #selector(changePasswordTypeToVerbal))
            ]),
            .init(in: self, title: "Change Password Type", action: #selector(changePasswordType))
        ]
        
        return menu
    }
    
    func createEditMenu() -> NSMenuItem {
        let menu: NSMenuItem = .init()
        
        menu.submenu = .init(title: "Edit")
        menu.submenu?.items = [
//            .init(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z"),
//            .init(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z"),

//            .separator(),
            
            .init(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"),
            .init(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"),
            .init(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"),
            
            .separator(),
            
            .init(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
            
            // Separator
            
            // Start dictating
            // Emoji
        ]
        
        return menu
    }
    
    func createViewMenu() -> NSMenuItem {
        let menu: NSMenuItem = .init()
        
        menu.submenu = .init(title: "View")
        menu.submenu?.items = [
            // Enter full screen
        ]
        
        return menu
    }
    
    func createWindowMenu() -> NSMenuItem {
        let menu: NSMenuItem = .init()
        
        menu.submenu = .init(title: "Window")
        menu.submenu?.items = [
            //.init(title: "Minmize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m"),
            //.init(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: ""),
            
            //.separator(),
            
            .init(title: "Show All", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "m")
        ]
        
        return menu
    }
    
    func createHelpMenu() -> NSMenuItem {
        let menu: NSMenuItem = .init()
        
        menu.submenu = .init(title: "Help")
        menu.submenu?.items = [
            // Search
        ]
        
        return menu
    }
}

// MARK:- Selectors
private extension AppMenu {
    @objc func generate() { passwordSettings.passwordsAreBeingGenerated = true }
    
    @objc func changePasswordType() { passwordSettings.type.nextCase() }
    @objc func changePasswordTypeToRandomized() { passwordSettings.type = .randomized }
    @objc func changePasswordTypeToVerbal() { passwordSettings.type = .verbal }
}

// MARK:- Helpers
private extension NSMenuItem {
    convenience init(
        title: String,
        key: String? = nil,
        modifier: NSEvent.ModifierFlags? = nil,
        action selector: Selector?
    ) {
        self.init(title: title, action: selector, keyEquivalent: key ?? "")
        self.keyEquivalentModifierMask = modifier ?? []
    }
    
    convenience init(
        in target: AnyObject,
        title: String,
        key: String? = nil,
        modifier: NSEvent.ModifierFlags? = nil,
        action selector: Selector?
    ) {
        self.init(title: title, key: key, modifier: modifier, action: selector)
        self.target = target
    }
    
    convenience init(
        title: String,
        key: String? = nil,
        modifier: NSEvent.ModifierFlags? = nil,
        subItems: [NSMenuItem]
    ) {
        self.init(title: "\(title)...", key: key, modifier: modifier, action: nil)
        submenu = {
            let subMenu: NSMenu = .init()
            subMenu.items.append(contentsOf: subItems)
            return subMenu
        }()
    }
}

private final class Action: NSObject {
    private let block: () -> Void

    init(action: @escaping () -> Void) {
        block = action
        super.init()
    }

    @objc func action() { block() }
}
