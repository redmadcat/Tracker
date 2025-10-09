//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DomainDataLayer.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let tracker = TrackerCategoryCoreData(context: context)
        tracker.header = trackerCategory.header
        try context.save()
    }
}
