//
//  Characters.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Chracters
extension PasswordSettings {
    struct Characters {
        // MARK: Properties
        var lowercase: CharacterType
        var uppercase: CharacterType
        var digits: CharacterType
        var symbols: CharacterType
        var ambiguous: CharacterType
        
        var allTypes: [CharacterType] { [lowercase, uppercase, digits, symbols, ambiguous] }
        
        var length: Int { allTypes.map { $0.count }.reduce(0, +) }
        
        static var consecutiveInAlphabet: String = PasswordSettings.CharacterSet.lowercase.characters
        static var consecutiveInNumbers: String = PasswordSettings.CharacterSet.digits.characters
        static var consecutiveOnKeyboard: [String] = [
            "1q", "qa", "az",
            "2w", "ws", "sx",
            "3e", "ed", "dc",
            "4r", "rf", "fv",
            "5t", "tg", "gb",
            "6y", "yh", "hn",
            "7u", "uj", "jm",
            "8i", "ik", "ol",
            "9o",
            "0p",
            
            "qw", "we", "er", "rt", "ty", "yu", "ui", "io", "op",
            "as", "sd", "df", "fg", "gh", "hj", "jk", "kl",
            "zx", "xc", "cv", "vb", "bn", "nm"
        ]
        
        // MARK: Initializers
        init() {
            lowercase = .init(characters: .lowercase, isIncluded: true)
            uppercase = .init(characters: .uppercase, isIncluded: true)
            digits = .init(characters: .digits, isIncluded: true)
            symbols = .init(characters: .symbols, isIncluded: true)
            ambiguous = .init(characters: .ambiguous, isIncluded: false)
        }
        
        // MARK: Methods
        mutating func setCheck(to isIncluded: Bool, for type: CharacterSet) {
            switch type {
            case .lowercase: lowercase.isIncluded = isIncluded
            case .uppercase: uppercase.isIncluded = isIncluded
            case .digits: digits.isIncluded = isIncluded
            case .symbols: symbols.isIncluded = isIncluded
            case .ambiguous: ambiguous.isIncluded = isIncluded
            }
        }
        
        mutating func updateCount(to count: Int, for type: CharacterSet) {
            switch type {
            case .lowercase: lowercase.count = count
            case .uppercase: uppercase.count = count
            case .digits: digits.count = count
            case .symbols: symbols.count = count
            case .ambiguous: ambiguous.count = count
            }
        }
    }
}

// MARK:- Chracter Type
extension PasswordSettings {
    struct CharacterType: Hashable {
        // MARK: Properties
        let characters: CharacterSet
        var isIncluded: Bool
        var count: Int = 0

        // MARK: Initializers
        init(characters: CharacterSet, isIncluded: Bool) {
            self.characters = characters
            self.isIncluded = isIncluded
        }
    }
}

// MARK:- Character Set
extension PasswordSettings {
    enum CharacterSet: Int, CaseIterable, Identifiable {
        case lowercase, uppercase, digits, symbols, ambiguous
        
        var id: Int { rawValue }
        
        func characters(includesSimilar: Bool) -> String {
            includesSimilar ? characters : charactersWithoutSimilars
        }
        
        var characters: String {
            switch self {
            case .lowercase: return "abcdefghijklmnopqrstuvwxyz"
            case .uppercase: return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            case .digits: return "0123456789"
            case .symbols: return "!@#$%^&*()"
            case .ambiguous: return "`~-_=+[]{}\\|;:'\",.<>/?"
            }
        }
        
        private var charactersWithoutSimilars: String {
            switch self {
            case .lowercase: return "acdefhijkmnoprstuvwxyz"
            case .uppercase: return "ABCDEFHJKLMNPQRUVWXYZ"
            case .digits: return "2348"
            case .symbols: return characters
            case .ambiguous: return characters
            }
        }
        
        var firstCharacter: Character {
            switch self {
            case .lowercase: return "a"
            case .uppercase: return "A"
            case .digits: return "2"
            case .symbols: return "!"
            case .ambiguous: return "`"
            }
        }
        
        func standardWegiths(readability: PasswordSettings.Readability) -> Int {
            switch (readability, self) {
            case (.low, .lowercase): return 50
            case (.low, .uppercase): return 35
            case (.low, .digits): return 15
            case (.low, .symbols): return 9
            case (.low, .ambiguous): return 3

            case (.medium, .lowercase): return 75
            case (.medium, .uppercase): return 25
            case (.medium, .digits): return 10
            case (.medium, .symbols): return 6
            case (.medium, .ambiguous): return 2

            case (.high, .lowercase): return 100
            case (.high, .uppercase): return 15
            case (.high, .digits): return 5
            case (.high, .symbols): return 3
            case (.high, .ambiguous): return 1
            }
        }
    }
}
