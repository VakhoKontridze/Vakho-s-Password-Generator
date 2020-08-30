//
//  Characters.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import Combine

// MARK:- Chracters
extension PasswordSettings {
    final class Characters: ObservableObject {
        // MARK: Properties
        @Published var lowercase: CharacterType
        @Published var uppercase: CharacterType
        @Published var digits: CharacterType
        @Published var symbols: CharacterType
        @Published var ambiguous: CharacterType
        
        var allCases: [CharacterType] { [lowercase, uppercase, digits, symbols, ambiguous] }
        
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
        
        var subscriptions: Set<AnyCancellable> = []
        
        // MARK: Initializers
        init() {
            lowercase = .init(characters: .lowercase, isIncluded: true)
            uppercase = .init(characters: .uppercase, isIncluded: true)
            digits = .init(characters: .digits, isIncluded: true)
            symbols = .init(characters: .symbols, isIncluded: true)
            ambiguous = .init(characters: .ambiguous, isIncluded: false)
            
            allCases.forEach { subscriptions.insert($0.objectWillChange.sink(receiveValue: { [weak self] in self?.objectWillChange.send() })) }
        }
    }
}

// MARK:- Chracter Type
extension PasswordSettings {
    final class CharacterType: NSObject, ObservableObject {
        // MARK: Properties
        let characters: CharacterSet
        @Published var isIncluded: Bool
        @Published var count: Int!

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
    }
}
