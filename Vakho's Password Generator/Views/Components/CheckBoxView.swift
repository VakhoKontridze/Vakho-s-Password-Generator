//
//  CheckBoxView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Check Box View
struct CheckBoxView: View {
    // MARK: Properties
    @Binding private var isOn: Bool
    
    private let title: String
    private let details: String
    
    // MARK: Initializers
    init(isOn: Binding<Bool>, characters: PasswordSettings.PasswordSettingsRandomized.CharacterSet) {
        self.init(isOn: isOn, title: characters.title, details: characters.details)
    }
    
    init(isOn: Binding<Bool>, setting: PasswordSettings.PasswordSettingsRandomized.AdditionalSetting) {
        self.init(isOn: isOn, title: setting.title, details: setting.details)
    }
    
    private init(isOn: Binding<Bool>, title: String, details: String) {
        self._isOn = isOn
        self.title = title
        self.details = details
    }
}

// MARK:- Body
extension CheckBoxView {
    var body: some View {
        Toggle(isOn: $isOn, label: {
            VStack(alignment: .leading, content: {
                Text(title)

                Text(details)
                    .font(.caption)
                    .foregroundColor(.secondary)
            })
                .padding(.leading, 5)
        })
    }
}

// MARK:- Preview
struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(isOn: .constant(true), characters: .lowercase)
    }
}
