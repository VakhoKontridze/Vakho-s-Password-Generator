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
    // MARK: Properties
    @ObservedObject private var settings: PasswordSettings
    
    // MARK: Initializers
    init(settings: PasswordSettings) {
        self.settings = settings
    }
}


// MARK:- Body
extension RandomizedView {
    var body: some View {
        VStack(content: {
            characters
            additional
        })
    }
    
    private var characters: some View {
        SectionView(title: "Characters and Readability", content: {
            HStack(spacing: 0, content: {
                Text("Readability:")
                
                Picker(selection: self.$settings.randomized.readability, label: EmptyView(), content: {
                    ForEach(PasswordSettings.PasswordSettingsRandomized.Readability.allCases, id: \.self, content: { readability in
                        Text(readability.title)
                    })
                })
                    .frame(width: 120)
            })
            
            ForEach(PasswordSettings.PasswordSettingsRandomized.CharacterSet.allCases, content: { characters in
                HStack(content: {
                    CheckBoxView(
                        isOn: .init(
                            get: {
                                self.settings.randomized.characters.map { $0.characters }.contains(characters)
                            },
                            set: { isOn in
//                                switch isOn { // ???
//                                case false: self.settings.randomized.characters.remove(<#T##member: PasswordSettings.PasswordSettingsRandomized.Characters##PasswordSettings.PasswordSettingsRandomized.Characters#>)
//                                case true: self.settings.randomized.characters.insert(characters)
//                                }
                            }
                        ),

                        characters: characters
                    )
                        .frame(alignment: .leading)
                    
                    Spacer()

                    Slider(value: .constant(50), in: 1...100)
                        .frame(width: 100)
                })
            })
        })
    }
    
    private var additional: some View {
        SectionView(title: "Additional", content: {
            ForEach(PasswordSettings.PasswordSettingsRandomized.AdditionalSetting.allCases, content: { setting in
                CheckBoxView(
                    isOn: .init(
                        get: {
                            self.settings.randomized.additional.contains(setting)
                        },
                        set: { isOn in
                            switch isOn {
                            case false: self.settings.randomized.additional.remove(setting)
                            case true: self.settings.randomized.additional.insert(setting)
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
        RandomizedView(settings: .init())
    }
}
