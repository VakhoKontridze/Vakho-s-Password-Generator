//
//  Separator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Separator
extension PasswordSettings {
    struct Separator {
        // MARK: Properties
        var isEnabled: Bool = false
        
        var characterChunkQunatity = 4
        static let range: ClosedRange<Int> = 4...64
        
        static let separator: String = "-"
        
        // MARK: Methods
        func length(characterLength: Int) -> Int {
            // 9    **** **** *
            // 10   **** **** **
            // 11   **** **** ***
            // 12   **** **** ****
            guard isEnabled else { return 0 }
            
            let fullChunks: Int = characterLength / characterChunkQunatity
            let halfChunk: Int = (characterLength - fullChunks * characterChunkQunatity) > 0 ? 1 : 0
            
            return fullChunks + halfChunk - 1
        }
    }
}
