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
    @Binding private var value: Int
    @State private var rawValue: String = ""
    
    private let range: ClosedRange<Int>
    
    // MARK: Initializers
    init(value: Binding<Int>, range: ClosedRange<Int>) {
        self._value = value
        self.range = range
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
                
                self.value = value
            }
        )
            .frame(width: 40)
            .multilineTextAlignment(.trailing)
    }
}

// MARK:- Preview
struct NumberTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        NumberTextFieldView(value: .constant(10), range: 1...100)
    }
}
