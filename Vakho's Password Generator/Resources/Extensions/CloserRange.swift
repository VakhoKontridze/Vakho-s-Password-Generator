//
//  CloserRange.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation

extension ClosedRange where Element == Int {
    var asDouble: ClosedRange<Double> {
        Double(lowerBound)...Double(upperBound)
    }
}
