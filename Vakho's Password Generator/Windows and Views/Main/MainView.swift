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
    @EnvironmentObject private var settings: PasswordSettings
    
    @State private var passwordsAreBeingGenerated: Bool = false
}

// MARK:- Body
extension MainView {
    var body: some View {
        VStack(content: {
            basic
            RandomizedView()
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
                self.qunatity
                self.type
            })
        })
    }
    
    private var length: some View {
        HStack(spacing: 3, content: {
            Text("Length: ")
                .frame(width: Layout.header.width, alignment: .leading)
            
            LogarithmicSliderView(value: $settings.characterLength, range: PasswordSettings.lengthRange)
                .frame(width: Layout.slider.width)
                .padding(.trailing, 5)
            
            NumberPickerView(value: settings.characterLength, range: PasswordSettings.lengthRange, completion: {
                self.settings.characterLength = $0
            })
            
            if settings.separator.isEnabled {
                Text("+ \(settings.separator.length(characterLength: settings.length)) separators")
                    .padding(.leading, 10)
                    .foregroundColor(.secondary)
            }
        })
    }
    
    private var qunatity: some View {
        HStack(spacing: 3, content: {
            Text("Quantity: ")
                .frame(width: Layout.header.width, alignment: .leading)
            
            NumberPickerView(value: settings.quantity, range: PasswordSettings.qunatityRange, completion: {
                self.settings.quantity = $0
            })
        })
    }
    
    private var type: some View {
        HStack(spacing: 3, content: {
            Text("Type: ")
                .frame(width: Layout.header.width, alignment: .leading)
            
            Picker(selection: self.$settings.type, label: EmptyView(), content: {
                ForEach(PasswordSettings.PasswordType.allCases, id: \.self, content: { type in
                    Text(type.title)
                })
            })
                .frame(width: Layout.typePicker.width)
        })
    }
    
    private var generate: some View {
        Button(action: { self.passwordsAreBeingGenerated = true }, label: { Text("Generate") })
            .disabled(settings.characters.allTypes.filter { $0.isIncluded }.isEmpty)
    }
}

// MARK:- Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(PasswordSettings())
    }
}
