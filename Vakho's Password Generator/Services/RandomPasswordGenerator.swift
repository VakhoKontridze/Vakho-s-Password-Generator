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
        retrieveCharacterCounts()
        
        while passwordsGenerated != settings.count {
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

// MARK:- Character Counts
private extension RandomPasswordGenerator {
    func retrieveCharacterCounts() {
        retreiveRawCounts()
        retreiveCounts()
    }
    
    func retreiveRawCounts() {
        for type in settings.characters.allTypes {
            let rawCount: Int = {
                guard type.isIncluded else { return 0 }

                let weight: Int = type.characters.standardWegiths(readability: settings.readability)
                let totalWeight: Int = {
                    settings.characters.allTypes
                        .filter { $0.isIncluded }
                        .map { $0.characters.standardWegiths(readability: settings.readability) }
                        .reduce(0, +)
                }()

                let ratio: Double = Double(weight) / Double(totalWeight)
                let count: Double = Double(settings.characterLength) * ratio

                return .init(count.rounded())
            }()
            
            settings.characters.updateCount(to: rawCount, for: type.characters)
        }
    }
    
    func retreiveCounts() {
        while settings.characters.length != settings.characterLength {
            var difference: Int = settings.characterLength - settings.characters.length
            var differenceExists: Bool { difference != 0 }
            let increment: Int = difference > 0 ? 1 : -1
            
            for type in settings.characters.allTypes {
                if differenceExists && type.isIncluded && type.count != 0 {
                    settings.characters.updateCount(to: type.count + increment, for: type.characters)
                    difference -= increment
                }
            }
        }
    }
}
