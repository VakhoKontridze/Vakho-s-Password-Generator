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
    @EnvironmentObject private var settings: PasswordSettings
    
    @State private var passwords: [String] = []
    private var progress: String {
        let ratio: Double = Double(passwords.count) / Double(settings.quantity)
        let percentage: Double = ratio * 100
        let percentageRounded: Int = .init(percentage.rounded())
        
        let progress: String = "\(passwords.count)/\(settings.quantity) (\(percentageRounded)%)"
        
        return progress
    }
    
    @State private var clipboardMessageIsShowing: Bool = false
    {
        willSet {
            guard newValue == true else { return }

            let _: Timer = .scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                self.clipboardMessageIsShowing = false
            })
        }
    }
}

// MARK:- Body
extension ResultsView {
    var body: some View {
        VStack(content: {
            progressAndBackButton
            passwordsList
            instructions
        })
            .frame(width: Layout.window.width, height: Layout.window.height)
            .padding(10)
            
            .background(Color.listBackground)   // Override on NSTableView is done in Colors.swift
            
            .onAppear(perform: fetch)
    }
    
    private var progressAndBackButton: some View {
        HStack(content: {
            Button(action: {
                self.cancellFetch()
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Back") })
            
            Spacer()
            
            Text(progress)
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
            .frame(height: 35)
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
            .fixedSize()
    }
    
    private func password(i: Int, password: String) -> some View {
        ZStack(alignment: .leading, content: {
            Rectangle()
                .cornerRadius(10)
                .foregroundColor(.formBackground)

            Text(password)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .font(.subheadline)
        })
            .onTapGesture(count: 2, perform: { self.copy(at: i) })
    }
    
    private var instructions: some View {
        Text(clipboardMessageIsShowing ? "Password has been copied to the clipboard" : "Double-tap a password to copy")
            .font(.footnote)
            .foregroundColor(.secondary)
    }
}

// MARK:- Fetch
private extension ResultsView {
    func fetch() {
        PasswordGenerator.shared.generate(completion: { password in
            DispatchQueue.main.async(execute: { self.passwords.append(password) })
        })
    }
    
    func cancellFetch() {
        PasswordGenerator.shared.shouldContinue = false
    }
}

// MARK:- Copy
private extension ResultsView {
    func copy(at index: Int) {
        let pasteboard: NSPasteboard = .general
        pasteboard.declareTypes([.string], owner: nil)

        pasteboard.setString(passwords[index], forType: .string)
        
        clipboardMessageIsShowing = true
    }
}

// MARK:- Preview
struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
            .environmentObject(PasswordSettings())
    }
}
