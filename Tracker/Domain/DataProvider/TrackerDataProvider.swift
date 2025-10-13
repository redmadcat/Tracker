//
//  TrackerCategoryDataProvider.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import Foundation
import CoreData

struct TrackerUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

final class TrackerDataProvider: NSObject, NSFetchedResultsControllerDelegate, TrackerDataProviderProtocol {
    // MARK: - Definition
    private weak var delegate: TrackerDataProviderDelegate?
    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore
    private let trackerStore: TrackerStore
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
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
    
    init(_ categoryStore: TrackerCategoryStore, _ trackerStore: TrackerStore) throws {
        self.categoryStore = categoryStore
        self.trackerStore = trackerStore
        self.context = DomainDataLayer.shared.context
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.update(TrackerUpdate(
            insertedIndexes: insertedIndexes!,
            deletedIndexes: deletedIndexes!
        ))
        insertedIndexes = nil
        deletedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
        
    // MARK: - TrackerDataProviderProtocol
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func addTrackerCategory(_ category: TrackerCategory) throws {
        if let categoryCoreData = try? categoryStore.addTrackerCategory(category) {
            if let tracker = category.trackers.last {
                try? addTracker(tracker, category: categoryCoreData)
            }
        }
    }
    
    private func addTracker(_ tracker: Tracker, category: TrackerCategoryCoreData) throws {
        try? trackerStore.addTracker(tracker, category: category)
    }
}
