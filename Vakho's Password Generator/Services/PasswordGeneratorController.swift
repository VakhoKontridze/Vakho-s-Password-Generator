//
//  PasswordGeneratorController.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import CoreData

// MARK:- Password Generator
protocol PasswordGenerator: class {
    func generate(completion: (String) -> Bool)
}

// MARK:- Password Generator Controller
final class PasswordGeneratorController {
    // MARK: Properties
    static let shared: PasswordGeneratorController = .init()
    
    var settings: SettingsViewModel!
    var managedObjectContext: NSManagedObjectContext!
    
    var shouldContinue: Bool = false    // Since DispatchQueue doesn't suspend process, manual flag is used
    
    // MARK: Initializers
    private init() {}
}

// MARK:- Generate
extension PasswordGeneratorController {
    func generate(completion: @escaping (String) -> Void) {
        shouldContinue = true
        
        DispatchQueue.global(qos: .userInteractive).async(execute: { [weak self] in
            guard let self = self else { return }
            
            let generator: PasswordGenerator = {
                switch self.settings.type {
                case .randomized:
                    return RandomPasswordGenerator(
                        length: self.settings.length,
                        lengthWithSeparator: self.settings.random.separator.totalLength(with: self.settings.length),
                        quantity: self.settings.quantity,
                        characters: self.settings.random.allTypes,
                        readability: self.settings.random.readability,
                        additionalSettings: self.settings.random.additionalSettings,
                        separator: self.settings.random.separator
                    )
                
                case .verbal:
                    return VerbalPasswordGenerator(
                        length: self.settings.length,
                        quantity: self.settings.quantity,
                        words: Word.fetch(from: self.managedObjectContext)
                    )
                }
            }()
            
            generator.generate(completion: { [weak self] password in
                completion(password)
                return self?.shouldContinue ?? false
            })
        })
    }
}
