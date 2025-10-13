//
//  TrackerStore.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData
import UIKit

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
        let schedule = tracker.schedule.map { String($0) }.joined(separator: "")
        
        let newTracker = TrackerCoreData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = tracker.color
        newTracker.schedule = schedule
        newTracker.category = category
        try context.save()
    }
}
