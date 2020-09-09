//
//  main.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Cocoa

private let appDelegate: AppDelegate = .init()
NSApplication.shared.delegate = appDelegate

private let menuBar: NSMenu = AppMenu(settings: appDelegate.passwordSettings)
NSApplication.shared.mainMenu = menuBar

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
