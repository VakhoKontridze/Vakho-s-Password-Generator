//
//  RandomizedLayout.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK: Randomized Layout
extension RandomizedView {
    struct Layout {
        // MARK: Properties
        static let header: CGSize = MainView.Layout.header
        static let weightsSection: CGSize = .init(width: 300, height: -1)
        static let readabilityPicker: CGSize = .init(width: 100, height: -1)
        
        // MARK: Initializers
        private init() {}
    }
}
