//
//  VerbalPasswordGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Verbal Password Generator
final class VerbalPasswordGenerator {
    // MARK: Properties
    private var passwordsLeftToGenerate: Int
    
    private let length: Int
    
    private let addedWords: [String]
    private let excludedWords: [String]
    
    // MARK: Initializers
    init(settings: PasswordSettings) {
        self.passwordsLeftToGenerate = settings.quantity
        
        self.length = settings.length
        
        self.addedWords = settings.addedWords
        self.excludedWords = settings.excludedWords
    }
}

// MARK:- Generate
extension VerbalPasswordGenerator {
    func generate(completion: (String) -> Bool) -> Void {
        guard safeguard() else { return }
        
        while passwordsLeftToGenerate > 0 {
            guard let password = generate() else { continue }
            passwordsLeftToGenerate -= 1

            let shouldContinue: Bool = completion(password)
            guard shouldContinue else { return }
        }
    }
    
    private func generate() -> String? {
        let password: String = retrieveWordLengths()
            .compactMap { PasswordSettings.Words.retrieveWord(length: $0) }
            .reduce("", { $0 + $1 })
        
        guard password.count == length else { return nil }
        
        return password
    }
}

// MARK:- Safeguard
private extension VerbalPasswordGenerator {
    func safeguard() -> Bool {
        !PasswordSettings.Words.words3Characters.isEmpty &&
        !PasswordSettings.Words.words4Characters.isEmpty &&
        !PasswordSettings.Words.words5Characters.isEmpty &&
        !PasswordSettings.Words.words6Characters.isEmpty &&
        !PasswordSettings.Words.words7Characters.isEmpty &&
        !PasswordSettings.Words.words8Characters.isEmpty
    }
}

// MARK:- Word Lenghts
private extension VerbalPasswordGenerator {
    func retrieveWordLengths() -> [Int] {
        let lengthRange: ClosedRange<Int> = {
            switch length {
            case 8...12: return 3...3
            case 13...16: return 3...4
            case 17...24: return 3...5
            case 25...32: return 3...6
            case 33...64: return 3...7
            case 65...: return 3...8
            default: return 3...3
            }
        }()
        
        var worldLengths: [Int] = []
        var totalLength: Int { worldLengths.reduce(0, +) }
        
        while totalLength != length {
            if totalLength < length {
                if let randomLength = lengthRange.randomElement() {
                    worldLengths.append(randomLength)
                }
            } else {
                if let randomIndex = worldLengths.indices.randomElement() {
                    worldLengths.remove(at: randomIndex)
                }
            }
        }
        
        return worldLengths.shuffled()
    }
}
