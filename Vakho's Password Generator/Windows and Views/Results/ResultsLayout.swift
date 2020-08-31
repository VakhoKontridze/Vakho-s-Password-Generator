//
//  ResultsLayout.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Results Layout
extension ResultsView {
    struct Layout {
        // MARK: Properties
        static let window: CGSize = .init(width: MainView.Layout.window.width - 40, height: MainView.Layout.window.height - 20)
        
        static let headerCornerItem: CGSize = .init(width: 150, height: -1)
        
        static let numbering: CGSize = .init(width: 25, height: -1)
        static let row: CGSize = .init(width: -1, height: 35)
        
        // MARK: Initializers
        private init() {}
    }
}
