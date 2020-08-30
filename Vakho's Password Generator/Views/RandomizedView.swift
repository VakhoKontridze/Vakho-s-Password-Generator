//
//  RandomizedView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Randomized View
struct RandomizedView: View {
    @EnvironmentObject private var settings: PasswordSettings
}


// MARK:- Body
extension RandomizedView {
    var body: some View {
        HStack(spacing: 10, content: {
            characters
            additional
        })
    }
    
    private var characters: some View {
        SectionView(title: "Characters", content: {
            ForEach(self.settings.characters.allCases, id: \.self, content: { type in
                HStack(content: {
                    CheckBoxView(
                        isOn: .init(
                            get: { type.isIncluded },
                            set: { isOn in self.settings.characters.allCases.first(where: { $0.characters == type.characters })?.isIncluded = isOn }
                        ),
                        
                        characters: type.characters
                    )
                    
                    Spacer()
                })
            })
            
            Spacer()
                .frame(height: 20)
            
            HStack(content: {
                Text("Readability:")
                
                Picker(selection: self.$settings.readability, label: EmptyView(), content: {
                    ForEach(PasswordSettings.Readability.allCases, id: \.self, content: { readability in
                        Text(readability.title)
                    })
                })
                    .frame(width: 100)
            })
        })
    }
    
    private var additional: some View {
        SectionView(title: "Additional", content: {
            ForEach(PasswordSettings.AdditionalSetting.allCases, content: { setting in
                CheckBoxView(
                    isOn: .init(
                        get: {
                            self.settings.additionalSettings.contains(setting)
                        },
                        set: { isOn in
                            switch isOn {
                            case false: self.settings.additionalSettings.remove(setting)
                            case true: self.settings.additionalSettings.insert(setting)
                            }
                        }
                    ),
                    
                    setting: setting
                )
            })
        })
    }
}

// MARK:- Preview
struct RandomizedView_Previews: PreviewProvider {
    static var previews: some View {
        RandomizedView()
            .environmentObject(PasswordSettings())
    }
}
