//
//  Word+CoreDataClass.swift
//  Vakho's Password Generator
//
//  Created by Vakhtang Kontridze on 8/31/20.
//  Copyright © 2020 Vakhtang Kontridze. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

// MARK:- Word
@objc(Word) public class Word: NSManagedObject {
    // MARK: Properties
    @NSManaged public var word: String?
    @NSManaged public var isAdded: Bool
    @NSManaged public var isExcluded: Bool
    
    // MARK: Initializers
    private convenience init(_ word: String, isAdded: Bool, in managedObjectContext: NSManagedObjectContext) {
        self.init(entity: Word.entity(), insertInto: managedObjectContext)

        self.word = word
        self.isAdded = isAdded
        self.isExcluded = !isAdded
        
        try? managedObjectContext.save()
    }
}

// MARK:- Fetch
extension Word {
    static var fetchRequest: NSFetchRequest<Word> {
        let fetchRequst: NSFetchRequest<Word> = .init(entityName: "Word")
        fetchRequst.sortDescriptors = [NSSortDescriptor(keyPath: \Word.word, ascending: true)]

        return fetchRequst
    }
    
    static func fetch(from managedObjectContext: NSManagedObjectContext) -> [Word] {
        (try? managedObjectContext.fetch(fetchRequest)) ?? []
    }
}

extension Array where Element == Word {
    var addedWords: Set<String> { .init(filter { $0.isAdded }.compactMap { $0.word }) }
    var excludedWords: Set<String> { .init(filter { $0.isExcluded }.compactMap { $0.word }) }
}

extension FetchedResults where Result == Word {
    var addedWords: Set<String> { Array(self).addedWords }
    var excludedWords: Set<String> { Array(self).excludedWords }
}

// MARK:- Modification
extension Word {
    static func create(_ word: String, isAdded: Bool, in managedObjectContext: NSManagedObjectContext) {
        if let existingWord = fetch(from: managedObjectContext).first(where: { $0.word == word }) {
            existingWord.isAdded = isAdded
            existingWord.isExcluded = !isAdded
            
            try? managedObjectContext.save()
        }
        
        else {
            let _: Word = .init(word, isAdded: isAdded, in: managedObjectContext)
        }
    }
    
    static func delete(_ word: String, from managedObjectContext: NSManagedObjectContext) {
        guard let word = fetch(from: managedObjectContext).first(where: { $0.word == word }) else { return }
        managedObjectContext.delete(word)
        
        try? managedObjectContext.save()
    }
}
