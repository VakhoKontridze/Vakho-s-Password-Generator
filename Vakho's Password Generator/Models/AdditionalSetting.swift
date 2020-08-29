//
//  AdditionalSetting.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Additional Setting
extension PasswordSettings.PasswordSettingsRandomized {
    enum AdditionalSetting: Int, CaseIterable, Identifiable {
        case startsWithLetter
        case similarCharacters
        case consecutiveCharacters
        case pairedDuplicateCharacters
        
        var id: Int { rawValue }
    }
}
