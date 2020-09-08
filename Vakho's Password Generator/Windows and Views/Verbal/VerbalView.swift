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
    @EnvironmentObject private var settings: SettingsViewModel
    @Environment(\.managedObjectContext) var managedObjectContext: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Word.fetchRequest) private var words: FetchedResults<Word>
}

// MARK:- Body
extension VerbalView {
    var body: some View {
        HStack(content: {
            WordEditView(
                title: "Added Words",
                words: words.addedWords,
                didAdd: { Word.create($0, isAdded: true, in: self.managedObjectContext) },
                didDelete: { Word.delete($0, from: self.managedObjectContext) }
            )
            
            WordEditView(
                title: "Excluded Words",
                words: words.excludedWords,
                didAdd: { Word.create($0, isAdded: false, in: self.managedObjectContext) },
                didDelete: { Word.delete($0, from: self.managedObjectContext) }
            )
        })
    }
}

// MARK:- Preview
struct VerbalView_Previews: PreviewProvider {
    static var previews: some View {
        VerbalView()
            .environment(\.managedObjectContext, (NSApp.delegate as! AppDelegate).managedObjectContext)
            .environmentObject(SettingsViewModel())
        
            .frame(width: MainView.Layout.view.width)
    }
}
