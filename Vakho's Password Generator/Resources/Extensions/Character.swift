//
//  Character.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

extension Character {
    var type: PasswordSettings.CharacterSet? {
        if PasswordSettings.CharacterSet.lowercase.characters.contains(self) { return .lowercase }
        if PasswordSettings.CharacterSet.uppercase.characters.contains(self) { return .uppercase }
        if PasswordSettings.CharacterSet.digits.characters.contains(self) { return .digits }
        if PasswordSettings.CharacterSet.symbols.characters.contains(self) { return .symbols }
        if PasswordSettings.CharacterSet.ambiguous.characters.contains(self) { return .ambiguous }
        return nil
    }
}
