//
//  RandomPasswordGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Random Password Generator
final class RandomPasswordGenerator {
    // MARK: Properties
    private var passwordsLeftToGenerate: Int
    
    private let length: Int
    private let lengthWithSeparator: Int
    
    private var characters: PasswordSettings.Characters
    private let readability: PasswordSettings.Readability
    private let additionalSettings: Set<PasswordSettings.AdditionalSetting>
    private let separator: PasswordSettings.Separator
    
    // MARK: Initializers
    init(settings: PasswordSettings) {
        self.passwordsLeftToGenerate = settings.quantity
        
        self.length = settings.length
        self.lengthWithSeparator = settings.lengthWithSeparator
        
        self.characters = settings.characters
        self.readability = settings.readability
        self.additionalSettings = settings.additionalSettings
        self.separator = settings.separator
    }
}

// MARK:- Generate
extension RandomPasswordGenerator {
    func generate(completion: (String) -> Bool) -> Void {
        retrieveCharacterQunatities()
        
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
        var characters = self.characters
        
        var password: String = ""
        
        retrieveFirstCharacter(from: &characters, writeIn: &password)
        guard retrieveCharacters(from: &characters, writeIn: &password) else { return nil }
        guard filter(&password) else { return nil }
        
        return password
    }
}

// MARK:- Character Qunatitiess
private extension RandomPasswordGenerator {
    func retrieveCharacterQunatities() {
        retreiveRawQuantities()
        retreiveQunatities()
    }
    
    func retreiveRawQuantities() {
        for type in characters.allTypes {
            let rawQunatity: Int = {
                guard type.isIncluded else { return 0 }

                let weight: Int = type.characters.standardWeight(readability: readability)
                let totalWeight: Int = {
                    characters.allTypes
                        .filter { $0.isIncluded }
                        .map { $0.characters.standardWeight(readability: readability) }
                        .reduce(0, +)
                }()

                let ratio: Double = Double(weight) / Double(totalWeight)
                let qunatity: Double = Double(length) * ratio

                return .init(qunatity.rounded())
            }()
            
            characters.updateQunatity(to: rawQunatity, for: type.characters)
        }
    }
    
    func retreiveQunatities() {
        while characters.length != length {
            var difference: Int = length - characters.length
            var differenceExists: Bool { difference != 0 }
            let increment: Int = difference > 0 ? 1 : -1
            
            for type in characters.allTypes {
                if differenceExists && type.isIncluded && type.qunatity > 0 {
                    characters.updateQunatity(to: type.qunatity + increment, for: type.characters)
                    difference -= increment
                }
            }
            
            for type in characters.allTypes.filter({ $0.isIncluded }) {
                if type.qunatity == 0 {
                    characters.updateQunatity(to: type.qunatity + 1, for: type.characters)
                    difference += increment
                }
            }
        }
    }
}

// MARK:- Retreive
private extension RandomPasswordGenerator {
    func retrieveFirstCharacter(from characters: inout PasswordSettings.Characters, writeIn password: inout String) {
        guard additionalSettings.contains(.startsWithLetter) else { return }
        guard characters.lowercase.isIncluded || characters.uppercase.isIncluded else { return }
        
        guard let characterType: PasswordSettings.CharacterSet = [.lowercase, .uppercase].randomElement() else { return }
        guard let character = characterType.characters(includesSimilar: additionalSettings.contains(.similarCharacters)).randomElement() else { return }
        
        password.append(character)
        
        switch characterType {
        case .lowercase: characters.lowercase.qunatity -= 1
        case .uppercase: characters.uppercase.qunatity -= 1
        default: break
        }
    }
    
    func retrieveCharacters(from characters: inout PasswordSettings.Characters, writeIn password: inout String) -> Bool {
        password += {
            var pool: String = ""
            
            for type in characters.allTypes.filter({ $0.isIncluded }) {
                type.qunatity.times { pool.append(self.retrieveRandomCharacter(from: type.characters)) }
            }

            return String(pool.shuffled())
        }()
        
        if separator.isEnabled {
            let rawString: JoinedSequence<[[String.Element]]> = Array(password)
                .chunked(into: separator.characterChunkQunatity)
                .joined(separator: PasswordSettings.Separator.separator)
            
            password = .init(rawString)
        }
        
        guard password.count == length else { return false }
        
        return true
    }
    
    func retrieveRandomCharacter(from characterSet: PasswordSettings.CharacterSet) -> Character {
        characterSet.characters(includesSimilar: additionalSettings.contains(.similarCharacters)).randomElement() ?? characterSet.firstCharacter
    }
}

// MARK:- Filter
private extension RandomPasswordGenerator {
    func filter(_ password: inout String) -> Bool {
        let containDuplicate: Bool = additionalSettings.contains(.pairedDuplicateCharacters)
        let containConsecutive: Bool = additionalSettings.contains(.consecutiveCharacters)
        
        for _ in 1...(10 * length) {
            let indexOpt: Int? = {
                switch (containDuplicate, containConsecutive) {
                case (false, false): return findDuplicateIndex(in: password) ?? findConsecutiveIndex(in: password)
                case (false, true): return findDuplicateIndex(in: password)
                case (true, false): return findConsecutiveIndex(in: password)
                case (true, true): return nil
                }
            }()
            guard let index = indexOpt else { return true }
            
            guard let type = password[index].type else { return false }
            password.replace(at: index, with: retrieveRandomCharacter(from: type))
        }
        
        return false
    }
    
    func findDuplicateIndex(in password: String) -> Int? {
        for i in 0..<length-1 where password[i] == password[i+1] {
            if additionalSettings.contains(.startsWithLetter) && i == 0 {
                return i+1
            } else {
                return i
            }
        }
        
        return nil
    }
    
    func findConsecutiveIndex(in password: String) -> Int? {
        for i in 0..<length-1 {
            let containsDuplicate: Bool = {
                let sequence1: String = "\(password[i])\(password[i+1])".lowercased()
                let sequence2: String = "\(password[i+1])\(password[i])".lowercased()
                
                guard !PasswordSettings.Characters.consecutiveInAlphabet.contains(sequence1) else { return true }
                guard !PasswordSettings.Characters.consecutiveInAlphabet.contains(sequence2) else { return true }
                
                guard !PasswordSettings.Characters.consecutiveInNumbers.contains(sequence1) else { return true }
                guard !PasswordSettings.Characters.consecutiveInNumbers.contains(sequence2) else { return true }
                
                guard !PasswordSettings.Characters.consecutiveOnKeyboard.contains(sequence1) else { return true }
                guard !PasswordSettings.Characters.consecutiveOnKeyboard.contains(sequence2) else { return true }
                
                return false
            }()
            guard containsDuplicate else { continue }
            
            if additionalSettings.contains(.startsWithLetter) && i == 0 {
                return i+1
            } else {
                return i
            }
        }
        
        return nil
    }
}
