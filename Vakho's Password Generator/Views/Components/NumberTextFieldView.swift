//
//  NumberTextFieldView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Number Text Field View
struct NumberTextFieldView: View {
    // MARK: Properties
    private let value: Int
    private let range: ClosedRange<Int>
    private let completion: (Int) -> Void
    
    @State private var rawValue: String = ""
    
    // MARK: Initializers
    init(value: Int, range: ClosedRange<Int>, completion: @escaping (Int) -> Void) {
        self.value = value
        self.range = range
        self.completion = completion
    }
}

// MARK:- Body
extension NumberTextFieldView {
    var body: some View {
        TextField(
            "",
            
            text: .init(
                get: { String(self.value) },
                set: { value in self.rawValue = value }
            ),
            
            onCommit: {
                guard let rawValue = Int(self.rawValue) else { return }
                
                let value: Int = {
                    switch rawValue {
                    case self.range: return rawValue
                    case ..<self.range.lowerBound: return self.range.lowerBound
                    default: return self.range.upperBound // self.range.upperBound>..
                    }
                }()
                
                self.completion(value)
            }
        )
            .frame(width: 40)
            .multilineTextAlignment(.trailing)
    }
}

// MARK:- Preview
struct NumberTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        NumberTextFieldView(value: 10, range: 1...100, completion: { _ in })
    }
}
