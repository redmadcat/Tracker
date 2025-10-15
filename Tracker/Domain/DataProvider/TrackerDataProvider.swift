//
//  TrackerCategoryDataProvider.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import Foundation
import CoreData

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

final class TrackerDataProvider: NSObject, NSFetchedResultsControllerDelegate, TrackerDataProviderProtocol {
    // MARK: - Definition
    private weak var delegate: TrackerDataProviderDelegate?
    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore
    private let trackerStore: TrackerStore
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    private lazy var fetchedCategoryResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "header", ascending: false)
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
    
    private lazy var fetchedTrackerResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
                
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
      
    lazy var categories: [TrackerCategory] = {
        guard let categoryObjects = self.fetchedCategoryResultsController.fetchedObjects,
              let trackerObjects =  self.fetchedTrackerResultsController.fetchedObjects else { return [] }
                      
        let trackersByCategory = Dictionary(grouping: trackerObjects, by: { $0.category?.header })
                
        return categoryObjects.compactMap { categoryObject in
            let header = categoryObject.header ?? ""
            let trackersAtCategory = trackersByCategory[header] ?? []
            let trackers: [Tracker] = trackersAtCategory.compactMap { try? trackerStore.transformToTracker(from: $0) }
            return TrackerCategory(header: header, trackers: trackers)
        }
    }()
        
    init(_ categoryStore: TrackerCategoryStore, _ trackerStore: TrackerStore, delegate: TrackerDataProviderDelegate) throws {
        self.delegate = delegate
        self.categoryStore = categoryStore
        self.trackerStore = trackerStore
        self.context = DomainDataLayer.shared.context
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updatedIndexes: updatedIndexes!,
                movedIndexes: movedIndexes!
        ))
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }
    
    // MARK: - TrackerDataProviderProtocol
    func addTrackerCategory(_ category: TrackerCategory) throws {
        if let categoryCoreData = try? categoryStore.addTrackerCategory(category) {
            if let tracker = category.trackers.last {
                try? trackerStore.addTracker(tracker, category: categoryCoreData)
            }
        }
    }
}
