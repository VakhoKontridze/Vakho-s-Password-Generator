//
//  PasswordSettings.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import Combine

// MARK:- Password Settings
final class PasswordSettings: ObservableObject {
    @Published var count: Int = 10
    static let countRange: ClosedRange<Int> = 1...100
    
    @Published var characterLength: Int = 16
    var length: Int { characterLength + separator.length(characterLength: characterLength) }
    static let lengthRange: ClosedRange<Int> = 8...1024
    
    @Published var type: PasswordType = .randomized
    
    @Published var characters: Characters = .init()
    @Published var readability: Readability = .high
    @Published var additionalSettings: Set<AdditionalSetting> = [.startsWithLetter]
    @Published var separator: Separator = .init()
}
