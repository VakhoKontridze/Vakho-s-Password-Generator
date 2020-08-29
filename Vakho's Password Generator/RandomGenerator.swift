//
//  RandomGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Random Generator
final class RandomGenerator {
    // MARK: Properties
    private let settings: PasswordSettings
    
    private lazy var totalWeight: Int = {
        settings.randomized.characters
            .filter { settings.randomized.characters.contains($0) }
            .map { RandomGenerator.retrieveStandardWeights(characters: $0.characters, readability: settings.randomized.readability) }
            .reduce(0, +)
    }()
    
    // MARK: Initializers
    init(settings: PasswordSettings) {
        self.settings = settings
    }
}

// MARK:- Generate
extension RandomGenerator {
    func generate() -> Void {
        let (lowercase, uppercase, digits, symbols, ambiguous) = retreiveCounts()
        print(lowercase, uppercase, digits, symbols, ambiguous)
    }
}

// MARK:- Count and Weights
extension RandomGenerator {
    private func retreiveCounts() -> (Int, Int, Int, Int, Int) {
        var lowercase: Int = retreiveRawCount(for: .lowercase)
        var uppercase: Int = retreiveRawCount(for: .uppercase)
        var digits: Int = retreiveRawCount(for: .digits)
        var symbols: Int = retreiveRawCount(for: .symbols)
        var ambiguous: Int = retreiveRawCount(for: .ambiguous)
        
        var count: Int {
            [lowercase, uppercase, digits, symbols, ambiguous]
                .filter({ $0 > 0 })
                .reduce(0, +)
        }
        
        while count != settings.basic.length {
            var difference: Int = settings.basic.length - count
            var differenceExists: Bool { difference != 0 }
            let increment: Int = difference > 0 ? 1 : -1
            
            if differenceExists && lowercase != 0 { lowercase += increment; difference -= increment }   // != 0 means that character was not included in settings
            if differenceExists && uppercase != 0 { uppercase += increment; difference -= increment }
            if differenceExists && digits != 0 { digits += increment; difference -= increment }
            if differenceExists && symbols != 0 { symbols += increment; difference -= increment }
            if differenceExists && ambiguous != 0 { ambiguous += increment; difference -= increment }
        }

        return (lowercase, uppercase, digits, symbols, ambiguous)
    }
    
    private func retreiveRawCount(for characters: PasswordSettings.PasswordSettingsRandomized.CharacterSet) -> Int {
        guard settings.randomized.characters.contains(characters) else { return 0 }
        
        let weight: Int = RandomGenerator.retrieveStandardWeights(characters: characters, readability: settings.randomized.readability)
        let ratio: Double = Double(weight) / Double(totalWeight)
        let count: Double = Double(settings.basic.length) * ratio
        
        return .init(count.rounded())
    }
    
    static func retrieveStandardWeights(
        characters: PasswordSettings.PasswordSettingsRandomized.CharacterSet,
        readability: PasswordSettings.PasswordSettingsRandomized.Readability
    ) -> Int {
        switch (readability, characters) {
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
            
        default: return 0
        }
    }
}
