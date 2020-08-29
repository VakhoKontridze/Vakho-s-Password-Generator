//
//  PasswordSettingsBasic.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Password Settings Basic
extension PasswordSettings {
    final class PasswordSettingsBasic: ObservableObject {
        @Published var count: Int = 10
        static let countRange: ClosedRange<Int> = 1...100
        
        @Published var length: Int = 16
        static let lengthRange: ClosedRange<Int> = 8...1024
        
        @Published var type: PasswordType = .randomized
    }
}
