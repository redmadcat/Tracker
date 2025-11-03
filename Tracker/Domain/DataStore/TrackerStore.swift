//
//  TrackerStore.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData
import UIKit

final class TrackerStore: TrackerStoreProtocol {
    // MARK: - Definition
    private let context: NSManagedObjectContext
        
    convenience init() {
        let context = DomainDataLayer.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - TrackerStoreProtocol
    func fetch() -> [TrackerCoreData]? {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: false)
        ]
        return try? context.fetch(request)
    }
        
    func add(_ tracker: Tracker, category: TrackerCategoryCoreData) throws {
        let newTracker = TrackerCoreData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = UIColorMarshalling.hexString(from: tracker.color)
        newTracker.schedule = tracker.schedule.map { String($0) }.joined(separator: "")
        newTracker.category = category
        try context.save()
    }
    
    func delete(_ tracker: Tracker) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        if let record = try? context.fetch(request).first {
            context.delete(record)
            try context.save()
        }
    }
    
    func update(_ tracker: Tracker, with category: TrackerCategoryCoreData) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        if let record = try? context.fetch(request).first {
            record.name = tracker.name
            record.emoji = tracker.emoji
            record.color = UIColorMarshalling.hexString(from: tracker.color)
            record.schedule = tracker.schedule.map { String($0) }.joined(separator: "")
            record.category = category
            try context.save()
        }
    }
}
