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
        let tracker = TrackerCoreData(context: context)
        tracker.id = tracker.id
        tracker.name = tracker.name
        tracker.emoji = tracker.emoji
        tracker.color = tracker.color
        tracker.schedule = tracker.schedule
        tracker.category = category
        try context.save()
    }
}
