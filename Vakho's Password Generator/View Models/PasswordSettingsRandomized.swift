//
//  PasswordSettingsRandomized.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import Combine

// MARK:- Password Settings Randomized
extension PasswordSettings {
    final class PasswordSettingsRandomized: ObservableObject {
        // MARK: Properties
        @Published var characters: Set<Characters> = {
            let array: [Characters] = [.lowercase, .uppercase, .digits, .symbols]
                .map { .init(characters: $0, count: RandomGenerator.retrieveStandardWeights(characters: $0, readability: .medium)) }
            
            return .init(array)
        }()
        @Published var readability: Readability = .medium
        
        @Published var additional: Set<AdditionalSetting> = [.startsWithLetter]
        
        @Published var excludedCharacters: String = ""
        @Published var separator: Separator = .init()
        
        private var subscriptions: Set<AnyCancellable> = []

        // MARK: Initializers
        init() {
            subscriptions.insert(separator.objectWillChange.sink(receiveValue: { [weak self] in self?.objectWillChange.send() }))
        }
    }
}
