//
//  DataManager.swift
//  Note'd
//
//  Created by Ariel on 12/29/22.
//

import Foundation
import CoreData

final class PersistenceController{
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("cannot load data \(error)")
            }
        }
    }
    
    public func saveContext(backgroundContext: NSManagedObjectContext? = nil) throws{ // saves new information
        let context = backgroundContext ?? container.viewContext
        guard context.hasChanges else { return}
        try context.save()
    }
}
