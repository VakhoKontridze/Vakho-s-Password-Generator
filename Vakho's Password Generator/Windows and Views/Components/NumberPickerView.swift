//
//  NumberPickerView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Number Picker View
struct NumberPickerView: View {
    // MARK: Properties
    private let value: Int
    private let range: ClosedRange<Int>
    private let completion: ((Int) -> Void)?
    
    @State private var valueStr: String = ""
    
    // MARK: Initializers
    init(value: Int, range: ClosedRange<Int>, completion: ((Int) -> Void)? = nil) {
        self.value = value
        self.range = range
        self.completion = completion
    }
}

// MARK:- Body
extension NumberPickerView {
    var body: some View {
        HStack(spacing: 0, content: {
            textField
            stepper
        })
    }
        
    private var textField: some View {
        TextField(
            "",
            
            text: .init(
                get: { String(self.value) },
                set: { newValue in self.valueStr = newValue }
            ),
            
            onCommit: {
                guard let rawValue = Int(self.valueStr) else { return }
                
                let value: Int = {
                    switch rawValue {
                    case self.range: return rawValue
                    case ..<self.range.lowerBound: return self.range.lowerBound
                    default: return self.range.upperBound // self.range.upperBound>..
                    }
                }()
                
                self.completion?(value)
            }
        )
            .frame(width: 40)
            
            .multilineTextAlignment(.trailing)
            .font(.system(.footnote, design: .monospaced))
    }
        
    private var stepper: some View {
        Stepper(
            "",
            
            value: .init(
                get: { self.value },
                set: { newValue in self.completion?(newValue) }
            ),
            
            in: range
        )
    }
}

// MARK:- Preview
struct NumberPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NumberPickerView(value: 10, range: 1...100)
    }
}
