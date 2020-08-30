//
//  PasswordType.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Password Type
extension PasswordSettings {
    enum PasswordType: Int, CaseIterable {
        case randomized, verbal
    }

}
