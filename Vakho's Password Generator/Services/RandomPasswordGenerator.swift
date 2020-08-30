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
    var settings: PasswordSettings
    
    private var passwordsGenerated: Int = 0
    
    // MARK: Initializers
    init(settings: PasswordSettings) {
        self.settings = settings
    }
}

// MARK:- Generate
extension RandomPasswordGenerator {
    func generate(completion: (String) -> Void) -> Void {
        retrieveCharacterQunatitys()
        
        while passwordsGenerated != settings.qunatity {
            let generator: RandomSinglePasswordGenerator = .init(
                length: settings.length,
                characters: settings.characters,
                additionalSettings: settings.additionalSettings,
                separator: settings.separator
            )
            
            guard let password = generator.generate() else { continue }
            passwordsGenerated += 1
            completion(password)
        }
    }
}

// MARK:- Character Qunatitys
private extension RandomPasswordGenerator {
    func retrieveCharacterQunatitys() {
        retreiveRawQunatitys()
        retreiveQunatitys()
    }
    
    func retreiveRawQunatitys() {
        for type in settings.characters.allTypes {
            let rawQunatity: Int = {
                guard type.isIncluded else { return 0 }

                let weight: Int = type.characters.standardWeight(readability: settings.readability)
                let totalWeight: Int = {
                    settings.characters.allTypes
                        .filter { $0.isIncluded }
                        .map { $0.characters.standardWeight(readability: settings.readability) }
                        .reduce(0, +)
                }()

                let ratio: Double = Double(weight) / Double(totalWeight)
                let qunatity: Double = Double(settings.characterLength) * ratio

                return .init(qunatity.rounded())
            }()
            
            settings.characters.updateQunatity(to: rawQunatity, for: type.characters)
        }
    }
    
    func retreiveQunatitys() {
        while settings.characters.length != settings.characterLength {
            var difference: Int = settings.characterLength - settings.characters.length
            var differenceExists: Bool { difference != 0 }
            let increment: Int = difference > 0 ? 1 : -1
            
            for type in settings.characters.allTypes {
                if differenceExists && type.isIncluded && type.qunatity != 0 {
                    settings.characters.updateQunatity(to: type.qunatity + increment, for: type.characters)
                    difference -= increment
                }
            }
        }
    }
}
