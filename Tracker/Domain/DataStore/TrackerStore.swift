//
//  TrackerStore.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData
import UIKit

private enum TrackerTransformError: Error {
    case transformErrorInvalidData
}

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DomainDataLayer.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
        
    func addTracker(_ tracker: Tracker, category: TrackerCategoryCoreData) throws {
        let newTracker = TrackerCoreData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = tracker.color
        newTracker.schedule = tracker.schedule.map { String($0) }.joined(separator: "")
        newTracker.category = category
        try context.save()
    }
    
    func transformToTracker(from coreDataObject: TrackerCoreData) throws -> Tracker {
        guard let id = coreDataObject.id,
              let name = coreDataObject.name,
              let color = coreDataObject.color as? UIColor,
              let emoji = coreDataObject.emoji,
              let values = coreDataObject.schedule
        else { throw TrackerTransformError.transformErrorInvalidData }
        
        let schedule = values.compactMap { $0.wholeNumberValue }
        
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }
}
