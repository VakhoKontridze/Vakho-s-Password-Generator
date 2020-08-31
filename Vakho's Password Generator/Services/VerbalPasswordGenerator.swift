//
//  VerbalPasswordGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Cocoa

// MARK:- Verbal Password Generator
final class VerbalPasswordGenerator {
    // MARK: Properties
    private var passwordsLeftToGenerate: Int
    
    private let length: Int
    
    private let addedWords: Set<String>
    private let excludedWords: Set<String>
    
    private let addedWordsGroped: [Int: [String]]
    private let excludedWordsGrouped: [Int: [String]]
    
    // MARK: Initializers
    init(settings: PasswordSettings, managedObjectContext: NSManagedObjectContext) {
        self.passwordsLeftToGenerate = settings.quantity
        
        self.length = settings.length
        
        self.addedWords = Word.fetch(from: managedObjectContext).addedWords
        self.excludedWords = Word.fetch(from: managedObjectContext).excludedWords

        self.addedWordsGroped = .init(grouping: addedWords, by: { $0.count })
        self.excludedWordsGrouped = .init(grouping: excludedWords, by: { $0.count })
    }
}

// MARK:- Generate
extension VerbalPasswordGenerator {
    func generate(completion: (String) -> Bool) -> Void {
        guard safeguard() else { return }
        
        var passwords: Set<String> = []
        
        while passwordsLeftToGenerate > 0 {
            guard let password = generate() else { continue }
            guard !passwords.contains(password) else { continue }
            
            passwords.insert(password)
            passwordsLeftToGenerate -= 1

            let shouldContinue: Bool = completion(password)
            guard shouldContinue else { return }
        }
    }
    
    func generate() -> String? {
        let wordLengths: [Int] = retrieveWordLengths()
        
        var password: String = ""
        for length in wordLengths {
            guard let word = retrieveWord(length: length) else { return nil }
            guard !password.contains(word) else { return nil }
            password += word
        }
        
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

// MARK: Retreive
private extension VerbalPasswordGenerator {
    func retrieveWord(length: Int) -> String? {
        for _ in 1...10 {
            guard let word = PasswordSettings.Words.retrieveWord(length: length, union: addedWords) else { continue }
            guard !excludedWords.contains(word) else { continue }
            
            return word
        }
        
        return nil
    }
}
