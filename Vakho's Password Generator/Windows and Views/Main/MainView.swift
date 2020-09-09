//
//  MainView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Main View
struct MainView: View {
    @EnvironmentObject private var settings: SettingsViewModel
    
    @State private var passwordsAreBeingGenerated: Bool = false
}

// MARK:- Body
extension MainView {
    var body: some View {
        VStack(content: {
            basic
            contextualSettings
            generate
        })
            .frame(
                minWidth: Layout.view.width,
                idealWidth: Layout.view.width,
                maxWidth: Layout.view.width,
                
                minHeight: Layout.view.height,
                idealHeight: Layout.view.height,
                maxHeight: Layout.view.height,
                
                alignment: .top
            )
            .padding(10)
        
            .sheet(isPresented: $passwordsAreBeingGenerated, content: {
                ResultsView()
                    .environmentObject(self.settings)
            })
    }
    
    private var basic: some View {
        SectionView(content: {
            VStack(alignment: .leading, content: {
                self.length
                self.quantity
                self.type
            })
        })
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var length: some View {
        HStack(spacing: 3, content: {
            Text("Length: ")
                .frame(width: Layout.header.width, alignment: .leading)

            LogarithmicSliderView(value: $settings.length, range: SettingsViewModel.lengthRange)
                .frame(width: Layout.slider.width)
                .padding(.trailing, 5)

            NumberPickerView(value: $settings.length, range: SettingsViewModel.lengthRange)

            if settings.random.separator.isEnabled {
                Text("+ \(settings.random.separator.length(from: settings.length)) separators")
                    .padding(.leading, 10)
                    .foregroundColor(.secondary)
            }
        })
    }
    
    private var quantity: some View {
        HStack(spacing: 3, content: {
            Text("Quantity: ")
                .frame(width: Layout.header.width, alignment: .leading)
            
            NumberPickerView(value: $settings.quantity, range: SettingsViewModel.quantityRange)
        })
    }
    
    private var type: some View {
        HStack(spacing: 3, content: {
            Text("Type: ")
                .frame(width: Layout.header.width, alignment: .leading)

            Picker(selection: self.$settings.type, label: EmptyView(), content: {
                ForEach(PasswordType.allCases, id: \.self, content: { type in
                    Text(type.title)
                })
            })
                .frame(width: Layout.typePicker.width)
        })
    }
    
    private var contextualSettings: some View {
        Group(content: {
            if self.settings.type == .randomized {
                RandomizedView()
            } else {
                VerbalView()
            }
        })
    }
    
    private var generate: some View {
        Button(action: { self.passwordsAreBeingGenerated = true }, label: { Text("Generate") })
            .disabled(settings.random.allTypes.filter { $0.isIncluded && $0.weight > 0 }.isEmpty)
    }
}

// MARK:- Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SettingsViewModel())
    }
}
