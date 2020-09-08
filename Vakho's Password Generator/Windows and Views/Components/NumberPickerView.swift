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
    @Binding private var value: Int
    
    @State private var valueStr: String = ""                    // Used as placeholder for TextField until changes are commited
    @State private var textFieldIsBeingModified: Bool = false   // Since TextField depends on value, it will flicker if user types number outside range. So, this state variable conditionally stops retreivieng actuall value
    
    private let useSlider: Bool
    
    private let range: ClosedRange<Int>
    
    // MARK: Initializers
    init(value: Binding<Int>, useSlider: Bool = false, range: ClosedRange<Int>) {
        self._value = value
        self.useSlider = useSlider
        self.range = range
    }
}

// MARK:- Body
extension NumberPickerView {
    var body: some View {
        HStack(spacing: 0, content: {
            if useSlider { slider }
            textField
            stepper
        })
    }
    
    private var slider: some View {
        Slider(
            value: .init(
                get: { .init(self.value) },
                set: { self.value = .init($0) }
            ),
            in: range.asDouble
        )
            .padding(.trailing, 7)
    }
        
    private var textField: some View {
        TextField(
            "",
            text: Binding<String>(
                get: { self.textFieldIsBeingModified ? self.valueStr : .init(self.value) },
                set: { newValue in self.valueStr = newValue }
            )
                .onChange({ self.textFieldIsBeingModified = true }),
            onCommit: {
                self.textFieldIsBeingModified = false
                
                guard let rawValue = Int(self.valueStr) else { return }
                
                let newValue: Int = {
                    switch rawValue {
                    case self.range: return rawValue
                    case ..<self.range.lowerBound: return self.range.lowerBound
                    default: return self.range.upperBound // self.range.upperBound>..
                    }
                }()
                
                self.value = newValue
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
                set: { newValue in self.value = newValue }
            ),
            in: range
        )
    }
}

// MARK:- Preview
struct NumberPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NumberPickerView(value: .constant(10), range: 1...100)
    }
}
