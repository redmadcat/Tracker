//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    // MARK: - Definition
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DomainDataLayer.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - TrackerCategoryStoreProtocol
    func add(_ trackerCategory: TrackerCategory) throws -> TrackerCategoryCoreData {
        if let existingCategory = findAt(header: trackerCategory.header) { return existingCategory }
        let category = TrackerCategoryCoreData(context: context)
        category.header = trackerCategory.header
        try context.save()
        return category
    }
    
    // MARK: - Private func
    private func findAt(header: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.header), header)
        
        guard let category = try? context.fetch(request) else { return nil }
        return category.count > 0 ? category.first : nil
    }
}
