//
//  VerbalView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Verbal View
struct VerbalView: View {
    @EnvironmentObject private var settings: PasswordSettings
}

// MARK:- Body
extension VerbalView {
    var body: some View {
        HStack(content: {
            WordEditView(title: "Added Words", words: self.$settings.addedWords, completion: { word in
                self.settings.excludedWords.remove(word)
            })
            
            WordEditView(title: "Excluded Words", words: self.$settings.excludedWords, completion: { word in
                self.settings.addedWords.remove(word)
            })
        })
    }
}

// MARK:- Preview
struct VerbalView_Previews: PreviewProvider {
    private static let settings: PasswordSettings = {
        let settings: PasswordSettings = .init()
        
        settings.addedWords = .init(PasswordSettings.Words.words3Characters.prefix(10))
        settings.excludedWords = .init(PasswordSettings.Words.words4Characters.prefix(10))
        
        return settings
    }()
    
    static var previews: some View {
        VerbalView()
            .environmentObject(settings)
        
            .frame(width: MainView.Layout.view.width)
    }
}
