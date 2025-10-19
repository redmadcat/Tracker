//
//  TrackerCategoryDataProvider.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import Foundation
import CoreData

final class TrackerDataProvider: NSObject, NSFetchedResultsControllerDelegate, TrackerDataProviderProtocol {
    // MARK: - Definition
    private weak var delegate: TrackerDataProviderDelegate?
    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore
    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore
        
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCategoryCoreData.header),
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
          
    lazy var categories: [TrackerCategory] = {
        guard let categoryObjects = self.fetchedResultsController.fetchedObjects,
              let trackerObjects = self.trackerStore.fetch() else { return [] }
                      
        let trackersByCategory = Dictionary(grouping: trackerObjects, by: { $0.category?.header })
                
        return categoryObjects.compactMap { categoryObject in
            let header = categoryObject.header ?? ""
            let trackersAtCategory = trackersByCategory[header] ?? []
            let trackers: [Tracker] = trackersAtCategory.compactMap { try? trackerStore.transform(from: $0) }
            return TrackerCategory(header: header, trackers: trackers)
        }
    }()
        
    init(_ categoryStore: TrackerCategoryStore, _ trackerStore: TrackerStore, _ recordStore: TrackerRecordStore,
         delegate: TrackerDataProviderDelegate) throws {
        self.delegate = delegate
        self.categoryStore = categoryStore
        self.trackerStore = trackerStore
        self.recordStore = recordStore
        self.context = DomainDataLayer.shared.context
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?,
                for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.store(self, newIndexPath: newIndexPath)
    }
            
    // MARK: - TrackerDataProviderProtocol
    func add(_ category: TrackerCategory) throws {
        if let categoryCoreData = try? categoryStore.add(category) {
            if let tracker = category.trackers.last {
                try? trackerStore.add(tracker, category: categoryCoreData)
            }
        }
    }
    
    func add(_ trackerRecord: TrackerRecord) throws {
        try recordStore.add(trackerRecord)
    }
    
    func delete(_ trackerRecord: TrackerRecord) throws {
        try recordStore.delete(trackerRecord)
    }
    
    func isCompleted(for trackerId: UUID, at date: Date) throws -> Bool? {
        return try recordStore.isCompleted(for: trackerId, at: date)
    }
    
    func count(at trackerId: UUID) -> Int {
        return recordStore.count(at: trackerId)
    }
}
