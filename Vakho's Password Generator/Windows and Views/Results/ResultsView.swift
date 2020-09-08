//
//  ResultsView.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/30/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import SwiftUI

// MARK:- Results View
struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var settings: SettingsViewModel
    
    @State private var passwords: [String] = []
    
    private var progress: String {
        let ratio: Double = Double(passwords.count) / Double(settings.quantity)
        let percentage: Double = ratio * 100
        let percentageRounded: String = .init(format: "%.1f", percentage)
        
        let progress: String = "\(passwords.count)/\(settings.quantity) (\(percentageRounded)%)"
        
        return progress
    }
    
    @State private var clipboardMessageIsShowing: Bool = false
    {
        willSet {
            guard newValue == true else { return }

            clipboardMessageTimer?.invalidate()
            clipboardMessageTimer = nil
            
            clipboardMessageTimer = .scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                self.clipboardMessageIsShowing = false
            })
        }
    }
    @State private var clipboardMessageTimer: Timer?
}

// MARK:- Body
extension ResultsView {
    var body: some View {
        VStack(content: {
            header
            passwordsList
        })
            .frame(width: Layout.window.width, height: Layout.window.height)
            .padding(10)
            
            .background(Color.listBackground)   // Override on NSTableView is done in Colors.swift
            
            .onAppear(perform: generate)
    }
    
    private var header: some View {
        HStack(content: {
            Group(content: {
                Button(action: {
                    self.cancellGeneration()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Back") })
            })
                .frame(width: Layout.headerCornerItem.width, alignment: .leading)
            
            Spacer()
            
            Text(clipboardMessageIsShowing ? "Password has been copied to the clipboard" : "Double-tap a password to copy")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(progress)
                .frame(width: Layout.headerCornerItem.width, alignment: .trailing)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
        })
    }
    
    private var passwordsList: some View {
        List(content: {
            ForEach(passwords.enumeratedArray(), id: \.offset, content: { (i, password) in
                self.row(i: i, password: password)
            })
        })
    }
    
    private func row(i: Int, password: String) -> some View {
        HStack(content: {
            self.number(i)
            self.password(i: i, password: password)
        })
            .padding(.trailing, 7)
    }
    
    private func number(_ i: Int) -> some View {
        ZStack(content: {
            Circle()
                .foregroundColor(.formBackground)
            
            Text(String(i + 1))
                .frame(width: Layout.numbering.width)
                .padding(5)
                .font(.footnote)
                .foregroundColor(.secondary)
        })
            .frame(height: Layout.row.height)
            .fixedSize(horizontal: true, vertical: false)
    }
    
    private func password(i: Int, password: String) -> some View {
        ZStack(alignment: .leading, content: {
            Rectangle()
                .cornerRadius(10)
                .foregroundColor(.formBackground)
            
            VStack(alignment: .leading, spacing: 3, content: {
                ForEach(Array(password).chunked(into: 50), id: \.self, content: { chunk in
                    Text(String(chunk))
                })
            })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
        })
            .onTapGesture(count: 2, perform: { self.copyToClipboard(from: i) })
    }
}

// MARK:- Generate
private extension ResultsView {
    func generate() {
        PasswordGeneratorController.shared.generate(completion: { password in
            DispatchQueue.main.async(execute: { self.passwords.append(password) })
        })
    }
    
    func cancellGeneration() {
        PasswordGeneratorController.shared.shouldContinue = false
    }
}

// MARK:- Copy
private extension ResultsView {
    func copyToClipboard(from index: Int) {
        let pasteboard: NSPasteboard = .general
        pasteboard.declareTypes([.string], owner: nil)

        pasteboard.setString(passwords[index], forType: .string)
        
        clipboardMessageIsShowing = true
        NSSound(named: "Tink")?.play()
    }
}

// MARK:- Preview
struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
            .environmentObject(SettingsViewModel())
    }
}
