//
//  RandomPasswordGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Random Generator
final class RandomPasswordGenerator {
    // MARK: Properties
    private var passwordsLeftToGenerate: Int
    
    private var characterLength: Int
    private var length: Int
    
    private var characters: PasswordSettings.Characters
    private var readability: PasswordSettings.Readability
    private var additionalSettings: Set<PasswordSettings.AdditionalSetting>
    private var separator: PasswordSettings.Separator
    
    // MARK: Initializers
    init(settings: PasswordSettings) {
        self.passwordsLeftToGenerate = settings.quantity
        
        self.characterLength = settings.characterLength
        self.length = settings.length
        
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
        
        while passwordsLeftToGenerate > 0 {
            let generator: RandomSinglePasswordGenerator = .init(
                length: length,
                characters: characters,
                additionalSettings: additionalSettings,
                separator: separator
            )

            guard let password = generator.generate() else { continue }
            passwordsLeftToGenerate -= 1

            let shouldContinue: Bool = completion(password)
            guard shouldContinue else { return }
        }
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
                let qunatity: Double = Double(characterLength) * ratio

                return .init(qunatity.rounded())
            }()
            
            characters.updateQunatity(to: rawQunatity, for: type.characters)
        }
    }
    
    func retreiveQunatities() {
        while characters.length != characterLength {
            var difference: Int = characterLength - characters.length
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
