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
    private let settings: PasswordSettings
    private let settingsRandomized: PasswordSettings
    
    private var passwordsGenerated: Int = 0
    
    // MARK: Initializers
    init(settings: PasswordSettings, settingsRandomized: PasswordSettings) {
        self.settings = settings
        self.settingsRandomized = settingsRandomized
    }
}

// MARK:- Generate
extension RandomPasswordGenerator {
    func generate(completion: @escaping (String) -> Void) -> Void {
        while passwordsGenerated != settings.count {
            let generator: RandomSinglePasswordGenerator = .init(
                length: settings.length,
                characters: settingsRandomized.characters,
                additionalSettings: settingsRandomized.additionalSettings
            )
            
            guard let password = generator.generate() else { continue }
            passwordsGenerated += 1
            completion(password)
        }
    }
}
