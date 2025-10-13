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
    
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws -> TrackerCategoryCoreData {
        if let existingCategory = findCategoryAt(header: trackerCategory.header) { return existingCategory }
        let category = TrackerCategoryCoreData(context: context)
        category.header = trackerCategory.header
        try context.save()
        return category
    }
    
    private func findCategoryAt(header: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.header), header)
        
        let category = try! context.fetch(request)
        return category.count > 0 ? category.first : nil
    }
}
