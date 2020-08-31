//
//  WorldEditView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import SwiftUI

// MARK:- Word Edit View
extension VerbalView {
    struct WordEditView: View {
        // MARK: Properties
        private let title: String
        
        @State private var word: String = ""
        @Binding private var words: Set<String>
        
        private let completion: ((String) -> Void)?
        
        // MARK: Initializers
        init(title: String, words: Binding<Set<String>>, completion: ((String) -> Void)? = nil) {
            self.title = title
            self._words = words
            self.completion = completion
        }
    }
}

// MARK:- Body
extension VerbalView.WordEditView {
    var body: some View {
        SectionView(title: title, content: {
            self.addField
            
            List(content: {
                ForEach(self.words.sorted(), id: \.self, content: { word in
                    self.row(word: word)
                })
            })
                .mask(Rectangle().cornerRadius(10))
        })
    }
    
    private var addField: some View {
        HStack(spacing: 10, content: {
            TextField("", text: self.$word)
                .mask(Rectangle().cornerRadius(7))
            
            Button(action: { self.add() }, label: { Text("Add") })
                .disabled(word.count < 3)
                
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
            
                .font(.caption)
                .foregroundColor(Color.green.opacity(0.75))
        })
    }
    
    private func row(word: String) -> some View {
        ZStack(alignment: .leading, content: {
            Rectangle()
                .cornerRadius(10)
                .foregroundColor(.formBackground)

            HStack(content: {
                Text(word)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                
                Button(action: { self.words.remove(word) }, label: { Text("Remove") } )
                    .buttonStyle(PlainButtonStyle())
                
                    .font(.caption)
                    .foregroundColor(Color.red.opacity(0.75))
            })
                .padding(.horizontal, 20)
        })
            .frame(height: VerbalView.Layout.row.height)
    }
}

// MARK:- Modification
private extension VerbalView.WordEditView {
    func add() {
        guard !word.isEmpty else { return }
        guard word.count >= 3 else { return }
        
        words.insert(word)
        completion?(word)
        
        word = ""
    }
}

// MARK:- Preview
struct WordEditView_Previews: PreviewProvider {
    static var previews: some View {
        VerbalView.WordEditView(title: "Added Words", words: .constant(["Abc", "Def", "Ghi"]))
            .frame(width: MainView.Layout.view.width / 2)
    }
}
