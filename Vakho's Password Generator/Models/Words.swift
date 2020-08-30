//
//  Words.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Words
extension PasswordSettings {
    final class Words {
        // MARK: Propertes
        static let words3Characters: [String] = retreiveWords(length: 3)
        static let words4Characters: [String] = retreiveWords(length: 4)
        static let words5Characters: [String] = retreiveWords(length: 5)
        static let words6Characters: [String] = retreiveWords(length: 6)
        static let words7Characters: [String] = retreiveWords(length: 7)
        static let words8Characters: [String] = retreiveWords(length: 8)
        
        // MARK: Initializers
        private init() {}
    }
}

// MARK:- Retreive
extension PasswordSettings.Words {
    static func retrieveWord(length: Int) -> String? {
        switch length {
        case 3: return words3Characters.randomElement()
        case 4: return words4Characters.randomElement()
        case 5: return words5Characters.randomElement()
        case 6: return words6Characters.randomElement()
        case 7: return words7Characters.randomElement()
        case 8: return words8Characters.randomElement()
        default: return nil
        }
    }
}

// MARK:- Decode
private extension PasswordSettings.Words {
    static func retreiveWords(length: Int) -> [String] {
        guard
            let url = Bundle.main.url(forResource: "Words\(length)Characters", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let words = json as? [String]
        else {
            return []
        }

        return words
    }
}
