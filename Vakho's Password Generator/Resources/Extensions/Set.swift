//
//  Set.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

extension Set where Element == PasswordSettings.PasswordSettingsRandomized.Characters {
    func contains(_ characters:  PasswordSettings.PasswordSettingsRandomized.CharacterSet) -> Bool {
        contains(where: { $0.characters == characters })
    }
}
