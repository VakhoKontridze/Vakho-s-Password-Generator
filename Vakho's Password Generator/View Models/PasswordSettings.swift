//
//  PasswordSettings.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import Combine

// MARK:- Password Settings
final class PasswordSettings: ObservableObject {
    // MARK: Properties
    @Published var count: Int = 10
    static let countRange: ClosedRange<Int> = 1...100
    
    @Published var length: Int = 16
    static let lengthRange: ClosedRange<Int> = 8...1024
    
    @Published var type: PasswordType = .randomized
    
    @Published var characters: Characters = .init()
    @Published var readability: Readability = .medium
    @Published var additionalSettings: Set<AdditionalSetting> = [.startsWithLetter]
        
    //    @Published var excludedCharacters: String = "" // ???
    //    @Published var separator: Separator = .init() // ???
    
//    @Published var settingsVerbal: PasswordSettingsVerbal = .init()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: Initializers
    init() {
        subscriptions.insert(characters.objectWillChange.sink(receiveValue: { [weak self] in self?.objectWillChange.send() }))
    }
}

// MARK:- Character counts
extension PasswordSettings {
    /*
    static func retrieveInitialCount(for characterSet: CharacterSet) -> Int {
        switch characterSet {
        case .lowercase: return 11
        case .uppercase: return 4
        case .digits: return 1
        case .symbols: return 1
        case .ambiguous: return 0
        }
    }
    
    func characterWasToggled(_ characterType: CharacterType, isOn: Bool) {
        characters.setCheckState(characterType, isOn: false)
        calculateCharacterCounts()
    }
    
    private func lengthDidChange() {
        switch type {
        case .randomized: calculateCharacterCounts()
        case .verbal: break // ???
        }
    }
    
    private func calculateCharacterCounts() {
        var lowercase: Int = retreiveRawCount(for: .lowercase)
        var uppercase: Int = retreiveRawCount(for: .uppercase)
        var digits: Int = retreiveRawCount(for: .digits)
        var symbols: Int = retreiveRawCount(for: .symbols)
        var ambiguous: Int = retreiveRawCount(for: .ambiguous)

        var count: Int { [lowercase, uppercase, digits, symbols, ambiguous].reduce(0, +) }

        while count != length {
            var difference: Int = length - count
            var differenceExists: Bool { difference != 0 }
            let increment: Int = difference > 0 ? 1 : -1

            if differenceExists && lowercase > 1 { lowercase += increment; difference -= increment }   // >1 means that character was not included in settings, and won't be dropped to 0
            if differenceExists && uppercase > 1 { uppercase += increment; difference -= increment }
            if differenceExists && digits > 1 { digits += increment; difference -= increment }
            if differenceExists && count > 1 { symbols += increment; difference -= increment }
            if differenceExists && ambiguous > 1 { ambiguous += increment; difference -= increment }
        }
        
        characters.update(lowercase: lowercase, uppercase: uppercase, digits: digits, symbols: symbols, ambiguous: ambiguous)
    }
    
    private func retreiveRawCount(for characterSet: PasswordSettings.CharacterSet) -> Int {
        guard characters.allCases.contains(where: { $0.count > 0 }) else { return 0 }

        let weight: Int = retrieveWeights(characters: characterSet, readability: readability)
        let totalWeight: Int = {
            characters.allCases
                .filter { $0.count > 0 }
                .map { retrieveWeights(characters: $0.characters, readability: readability) }
                .reduce(0, +)
        }()

        let ratio: Double = Double(weight) / Double(totalWeight)
        let count: Double = Double(length) * ratio

        return .init(count.rounded())
    }

    private func retrieveWeights(
        characters: PasswordSettings.CharacterSet,
        readability: PasswordSettings.Readability
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
    */
}
