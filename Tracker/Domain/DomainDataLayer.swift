//
//  CoreDataLayer.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData

final class DomainDataLayer {
    // MARK: - Definition
    static let shared = DomainDataLayer()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
            
    private init() {}
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                fatalError("Unresolved error \(error)")
            }
        }
    }
}
