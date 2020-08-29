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
    @ObservedObject private var settings: PasswordSettings = .init()
}

// MARK:- Body
extension MainView {
    var body: some View {
        VStack(content: {
            basic
            RandomizedView(settings: settings)
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
                self.generate
                self.count
                self.type
                self.passwordsOfLength
                self.length
            })
        })
            .frame(height: 31 + 2*20)
    }
    
    private var generate: some View {
        Text("Generate")
            .lineLimit(1)
            .layoutPriority(1)
    }
    
    private var count: some View {
        HStack(spacing: 0, content: {
            TextField(
                String(self.settings.basic.count),
                
                text: .init(
                    get: {
                        String(self.settings.basic.count)
                    },
                    set: { string in
                        guard let count = Int(string) else { return }
                        guard PasswordSettings.PasswordSettingsBasic.countRange.contains(count) else { return }
                        self.settings.basic.count = count
                    }
                )
            )
                .frame(width: 40)
                .multilineTextAlignment(.trailing)
            
            Stepper("", value: self.$settings.basic.count, in: PasswordSettings.PasswordSettingsBasic.countRange)
                .frame(height: 22, alignment: .bottom)  // Stepper is broken otherwise
        })
    }
    
    private var type: some View {
        Picker(selection: self.$settings.basic.type, label: EmptyView(), content: {
            ForEach(PasswordType.allCases, id: \.self, content: { type in
                Text(type.title)
            })
        })
            .frame(width: 120)
    }
    
    private var passwordsOfLength: some View {
        Text("passwords, of length")
            .lineLimit(1)
            .layoutPriority(1)
    }
    
    private var length: some View {
        HStack(spacing: 0, content: {
            Slider(
                value: .init(
                    get: {
                        return Double(self.settings.basic.length)
                    },
                    set: { value in
                        let value: Int = .init(value)
                        guard PasswordSettings.PasswordSettingsBasic.lengthRange.contains(value) else { return }
                        self.settings.basic.length = value
                    }
                ),
                
                in: PasswordSettings.PasswordSettingsBasic.lengthRange.asDouble,
                
                onEditingChanged: { _ in }
            )
                .frame(minWidth: 100, maxWidth: 200)
            
            TextField(
                String(self.settings.basic.length),
                
                text: .init(
                    get: {
                        String(self.settings.basic.length)
                    },
                    set: { string in
                        guard let length = Int(string) else { return }
                        guard PasswordSettings.PasswordSettingsBasic.lengthRange.contains(length) else { return }
                        self.settings.basic.length = length
                    }
                )
            )
                .frame(width: 40)
                .multilineTextAlignment(.trailing)
            
            Stepper("", value: self.$settings.basic.length, in: PasswordSettings.PasswordSettingsBasic.lengthRange)
                .frame(height: 22, alignment: .bottom)  // Stepper is broken otherwise
        })
    }
}

// MARK:- Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
