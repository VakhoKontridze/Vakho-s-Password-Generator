//
//  PasswordSettings.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/29/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//

import Foundation
import Combine

// MARK:- Password Settings
final class PasswordSettings: ObservableObject {
    // MARK: Properties
    @Published var basic: PasswordSettingsBasic = .init()
    @Published var randomized: PasswordSettingsRandomized = .init()
    @Published var verbal: PasswordSettingsVerbal = .init()
    
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: Initializers
    init() {
        subscriptions.insert(basic.objectWillChange.sink(receiveValue: { [weak self] in self?.objectWillChange.send() }))
        subscriptions.insert(randomized.objectWillChange.sink(receiveValue: { [weak self] in self?.objectWillChange.send() }))
        subscriptions.insert(verbal.objectWillChange.sink(receiveValue: { [weak self] in self?.objectWillChange.send() }))
    }
}
