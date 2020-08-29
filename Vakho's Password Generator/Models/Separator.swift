//
//  Separator.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

// MARK:- Separator
final class Separator: ObservableObject {
    @Published var isEnabled: Bool = false
    @Published var characterChunkCount = 4
    @Published var separator: String = "-"
}
