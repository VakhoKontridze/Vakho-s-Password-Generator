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
        VStack(spacing: 10, content: {
            HStack(spacing: 10, content: {
                self.characters
                self.additionalSettings
            })
            separator
        })
    }
    
    private var characters: some View {
        SectionView(title: "Characters", content: {
            ForEach(self.settings.characters.allTypes, id: \.self, content: { type in
                HStack(content: {
                    CheckBoxView(
                        isOn: .init(
                            get: { type.isIncluded },
                            set: { isChecked in
                                self.settings.characters.setCheck(to: isChecked, for: type.characters)
                                
                                if !self.settings.characters.lowercase.isIncluded && !self.settings.characters.uppercase.isIncluded {
                                    self.settings.additionalSettings.remove(.startsWithLetter)
                                }
                            }
                        ),
                        
                        characters: type.characters
                    )
                    
                    Spacer()
                })
            })
            
            Spacer()
                .frame(height: 20)
            
            HStack(spacing: 3, content: {
                Text("Readability: ")
                
                Picker(selection: self.$settings.readability, label: EmptyView(), content: {
                    ForEach(PasswordSettings.Readability.allCases, id: \.self, content: { readability in
                        Text(readability.title)
                    })
                })
                    .frame(width: 100)
            })
        })
    }
    
    private var additionalSettings: some View {
        SectionView(title: "Additional", content: {
            ForEach(PasswordSettings.AdditionalSetting.allCases, content: { setting in
                CheckBoxView(
                    isOn: .init(
                        get: {
                            self.settings.additionalSettings.contains(setting)
                        },
                        set: { isOn in
                            if
                                !self.settings.additionalSettings.contains(.startsWithLetter) &&
                                setting == .startsWithLetter &&
                                isOn &&
                                (!self.settings.characters.lowercase.isIncluded && !self.settings.characters.uppercase.isIncluded)
                            {
                                self.settings.characters.lowercase.isIncluded = true
                                self.settings.characters.uppercase.isIncluded = true
                            }
                            
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
    
    private var separator: some View {
        SectionView(title: nil, content: {
            HStack(spacing: 3, content: {
                CheckBoxView(isOn: self.$settings.separator.isEnabled)
                
                HStack(spacing: 3, content: {
                    Text("Delimeter password with separator every ")
                    
                    NumberTextFieldView(value: self.settings.separator.characterChunkCount, range: PasswordSettings.Separator.range, completion: {
                        self.settings.separator.characterChunkCount = $0
                    })
                    
                    Text(" characters")
                })
                    .disabled(!self.settings.separator.isEnabled)
                    .foregroundColor(self.settings.separator.isEnabled ? .primary : .secondary)
            })
        })
    }
}

// MARK:- Preview
struct RandomizedView_Previews: PreviewProvider {
    static var previews: some View {
        RandomizedView()
            .environmentObject(PasswordSettings())
        
            .frame(width: MainLayout.viewSize.width)
    }
}
