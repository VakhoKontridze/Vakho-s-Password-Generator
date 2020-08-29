//
//  Characters.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Chracters
extension PasswordSettings.PasswordSettingsRandomized {
    struct Characters: Hashable {
        let characters: CharacterSet
        var count: Int
        
        init(characters: CharacterSet, count: Int) {
            self.characters = characters
            self.count = count
        }
    }
}

// MARK:- Character Set
extension PasswordSettings.PasswordSettingsRandomized {
    enum CharacterSet: Int, CaseIterable, Identifiable {
        case lowercase, uppercase, digits, symbols, ambiguous
        
        var id: Int { rawValue }
    }
}
