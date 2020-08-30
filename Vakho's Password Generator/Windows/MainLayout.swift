//
//  MainLayout.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Main Layout
struct MainLayout {
    // MARK: Properties
    static let windowSize: CGSize = .init(width: viewSize.width, height: viewSize.height + titleBar.height)
    static let viewSize: CGSize = .init(width: 720, height: 720)
    
    static let titleBar: CGSize = .init(width: -1, height: 22)

    // MARK: Initializers
    private init() {}
}
