//
//  MainViewModel.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Main ViewModel
extension MainView {
    struct ViewModel {
        // MARK: Properties
        static let window: CGSize = .init(width: view.width, height: view.height + titleBar.height)
        static let titleBar: CGSize = .init(width: -1, height: 22)
        
        static let view: CGSize = .init(width: 650, height: 734 - 20)   // -20 comes from padding applied to the view
        
        static let header: CGSize = .init(width: 75, height: -1)
        static let slider: CGSize = .init(width: 200, height: -1)
        static let typePicker: CGSize = .init(width: 120, height: -1)

        // MARK: Initializers
        private init() {}
    }
}
