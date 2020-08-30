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
                minWidth: MainLayout.viewSize.width,
                idealWidth: MainLayout.viewSize.width,
                maxWidth: MainLayout.viewSize.width,
                
                minHeight: MainLayout.viewSize.height,
                idealHeight: MainLayout.viewSize.height,
                maxHeight: MainLayout.viewSize.height,
                
                alignment: .top
            )
            .padding(10)
    }
    
    private var basic: some View {
        SectionView(title: nil, content: {
            HStack(content: {
                self.generateHeader
                self.count
                self.type
                self.passwordsOfLengthHeader
                self.length
            })
        })
            .frame(height: 31 + 2*20)
    }
    
    private var generateHeader: some View {
        Text("Generate")
            .lineLimit(1)
            .layoutPriority(1)
    }
    
    private var count: some View {
        HStack(spacing: 0, content: {
            NumberTextFieldView(value: settings.count, range: PasswordSettings.countRange, completion: { value in
                self.settings.count = value
            })
            
            Stepper("", value: self.$settings.count, in: PasswordSettings.countRange)
                .frame(height: 22, alignment: .bottom)  // Stepper is broken otherwise
        })
    }
    
    private var type: some View {
        Picker(selection: self.$settings.type, label: EmptyView(), content: {
            ForEach(PasswordSettings.PasswordType.allCases, id: \.self, content: { type in
                Text(type.title)
            })
        })
            .frame(width: 120)
    }
    
    private var passwordsOfLengthHeader: some View {
        Text("passwords, of length")
            .lineLimit(1)
            .layoutPriority(1)
    }
    
    private var length: some View {
        HStack(spacing: 0, content: {
            Slider(
                value: .init(
                    get: { Double(self.settings.length) },
                    set: { value in self.settings.length = .init(value) }
                ),
                
                in: PasswordSettings.lengthRange.asDouble
            )
                .frame(minWidth: 100, maxWidth: 200)
            
            NumberTextFieldView(value: settings.length, range: PasswordSettings.lengthRange, completion: { value in
                self.settings.length = value
            })
            
            Stepper("", value: self.$settings.length, in: PasswordSettings.lengthRange)
                .frame(height: 22, alignment: .bottom)  // Stepper is broken otherwise
        })
    }
    
    private var generate: some View {
        Button(action: {  }, label: { Text("Generate") })
    }
}

// MARK:- Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(PasswordSettings())
    }
}
