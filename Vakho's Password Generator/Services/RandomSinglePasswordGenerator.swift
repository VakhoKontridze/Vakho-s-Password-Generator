//
//  RandomSinglePasswordGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Random Single Password Generator
final class RandomSinglePasswordGenerator {
    // MARK: Properties
    private let length: Int
    private var characters: PasswordSettings.Characters
    private let additionalSettings: Set<PasswordSettings.AdditionalSetting>

    private var password: String = ""
    
    // MARK: Initializers
    init(
        length: Int,
        characters: PasswordSettings.Characters,
        additionalSettings: Set<PasswordSettings.AdditionalSetting>
    ) {
        self.length = length
        self.characters = characters
        self.additionalSettings = additionalSettings
    }
}

// MARK:- Generate
extension RandomSinglePasswordGenerator {
    func generate() -> String? {
        retrieveFirstCharacter()
        guard retrieveCharacters() else { return nil }
        guard filter() else { return nil }
        
        return password
    }
}

// MARK:- Retreive
private extension RandomSinglePasswordGenerator {
    func retrieveFirstCharacter() {
        guard additionalSettings.contains(.startsWithLetter) else { return }
        guard let characterType: PasswordSettings.CharacterSet = [.lowercase, .uppercase].randomElement() else { return }
        guard let character = characterType.characters(includesSimilar: additionalSettings.contains(.similarCharacters)).randomElement() else { return }
        
        password.append(character)
        
        switch characterType {
        case .lowercase: characters.lowercase.count -= 1
        case .uppercase: characters.uppercase.count -= 1
        default: break
        }
    }
    
    func retrieveCharacters() -> Bool {
        let pool: String = {
            var pool: String = ""
            
            for type in characters.allCases {
                type.count.times { pool.append(self.retrieveRandomCharacter(from: type.characters)) }
            }

            return String(pool.shuffled())
        }()
        password += pool
        
        guard password.count == length else { return false }
        
        return true
    }
    
    func retrieveRandomCharacter(from characterSet: PasswordSettings.CharacterSet) -> Character {
        characterSet.characters(includesSimilar: additionalSettings.contains(.similarCharacters)).randomElement() ?? characterSet.firstCharacter
    }
}

// MARK:- Filter
private extension RandomSinglePasswordGenerator {
    func filter() -> Bool {
        let containDuplicate: Bool = additionalSettings.contains(.pairedDuplicateCharacters)
        let containConsecutive: Bool = additionalSettings.contains(.consecutiveCharacters)
        
        var loopsLeft: Int = 1000
        
        while true {
            guard loopsLeft > 0 else { return false }
            loopsLeft -= 1
            
            let indexOpt: Int? = {
                switch (containDuplicate, containConsecutive) {
                case (false, false): return findDuplicateIndex() ?? findConsecutiveIndex()
                case (false, true): return findDuplicateIndex()
                case (true, false): return findConsecutiveIndex()
                case (true, true): return nil
                }
            }()
            guard let index = indexOpt else { return true }
            
            guard let type = password[index].type else { return false }
            password.replace(at: index, with: retrieveRandomCharacter(from: type))
        }
    }
    
    func findDuplicateIndex() -> Int? {
        for i in 0..<length-1 where password[i] == password[i+1] {
            if additionalSettings.contains(.startsWithLetter) && i == 0 {
                return i+1
            } else {
                return i
            }
        }
        
        return nil
    }
    
    func findConsecutiveIndex() -> Int? {
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
