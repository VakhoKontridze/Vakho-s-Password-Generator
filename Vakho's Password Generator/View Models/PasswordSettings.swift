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
    // Basic
    @Published var quantity: Int = 10
    static let qunatityRange: ClosedRange<Int> = 1...100
    
    @Published var length: Int = 16
    static let lengthRange: ClosedRange<Int> = 8...1024
    
    @Published var type: PasswordType = .randomized
    
    // Random
    @Published var characters: Characters = .init()
    @Published var readability: Readability = .high
    @Published var additionalSettings: Set<AdditionalSetting> = [.startsWithLetter]
    @Published var separator: Separator = .init()
    var lengthWithSeparator: Int { length + separator.length(characterLength: length) }
    
    // Verbal
    @Published var addedWords: Set<String> = []
    @Published var excludedWords: Set<String> = []
}
