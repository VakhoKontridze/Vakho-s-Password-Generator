//
//  PasswordGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Password Generator
final class PasswordGenerator {
    // MARK: Properties
    static let shared: PasswordGenerator = .init()
    
    var settings: PasswordSettings!
    
    // MARK: Initializers
    private init() {}
}

// MARK:- Generate
extension PasswordGenerator {
    func generate(completion: (String) -> Void) {
        switch settings.type {
        case .randomized: RandomPasswordGenerator(settings: settings).generate(completion: completion)
        case .verbal: break // ???
        }
    }
}
