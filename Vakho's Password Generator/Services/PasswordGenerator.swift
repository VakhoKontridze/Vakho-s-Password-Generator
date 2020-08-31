//
//  PasswordGenerator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import CoreData

// MARK:- Password Generator
final class PasswordGenerator {
    // MARK: Properties
    static let shared: PasswordGenerator = .init()
    
    var settings: PasswordSettings!
    var managedObjectContext: NSManagedObjectContext!
    
    var shouldContinue: Bool = false    // Since DispatchQueue doesn't suspend process, manual flag is used
    
    // MARK: Initializers
    private init() {}
}

// MARK:- Generate
extension PasswordGenerator {
    func generate(completion: @escaping (String) -> Void) {
        shouldContinue = true
        
        DispatchQueue.global(qos: .userInteractive).async(execute: { [weak self] in
            guard let self = self else { return }
            
            switch self.settings.type {
            case .randomized:
                RandomPasswordGenerator(settings: self.settings)
                    .generate(completion: { [weak self] password in
                        completion(password)
                        return self?.shouldContinue ?? false
                    })
            
            case .verbal:
                VerbalPasswordGenerator(settings: self.settings, managedObjectContext: self.managedObjectContext)
                    .generate(completion: { [weak self] password in
                        completion(password)
                        return self?.shouldContinue ?? false
                    })
            }
        })
    }
}
