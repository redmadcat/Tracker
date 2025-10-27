//
//  TrackerCategoryDataProvider.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import CoreData

final class TrackerDataProvider: NSObject, NSFetchedResultsControllerDelegate, TrackerDataProviderProtocol {
    // MARK: - Definition
    weak var delegate: TrackerDataProviderDelegate?
    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStoreProtocol
    private let trackerStore: TrackerStoreProtocol
    private let recordStore: TrackerRecordStoreProtocol
    
    enum TrackerTransformError: Error {
        case transformErrorInvalidData
    }
        
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
        guard let categoryObjects = fetchedResultsController.fetchedObjects,
              let trackerObjects = trackerStore.fetch() else { return [] }
                      
        let trackersByCategory = Dictionary(grouping: trackerObjects, by: { $0.category?.header })
                
        return categoryObjects.compactMap { categoryObject in
            let header = categoryObject.header ?? ""
            let trackersAtCategory = trackersByCategory[header] ?? []
            let trackers: [Tracker] = trackersAtCategory.compactMap { try? transform(from: $0) }
            return TrackerCategory(header: header, trackers: trackers)
        }
    }()
        
    init(_ categoryStore: TrackerCategoryStoreProtocol, _ trackerStore: TrackerStoreProtocol, _ recordStore: TrackerRecordStoreProtocol,
         with context: NSManagedObjectContext) {
        self.categoryStore = categoryStore
        self.trackerStore = trackerStore
        self.recordStore = recordStore
        self.context = context
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?,
                for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.store(self, newIndexPath: newIndexPath)
    }
            
    // MARK: - TrackerDataProviderProtocol
    func fetch() throws -> [TrackerCategory]? {
        guard let result = try? categoryStore.fetch() else { return nil }
        return result.compactMap { try? transform(from: $0) }
    }
    
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
    
    func delete(_ trackerCategory: TrackerCategory) throws {
        try categoryStore.delete(trackerCategory)
    }
    
    func delete(_ trackerRecord: TrackerRecord) throws {
        try recordStore.delete(trackerRecord)
    }
    
    func update(_ trackerCategory: TrackerCategory, with header: String) throws {
        try categoryStore.update(trackerCategory, with: header)
    }
    
    func isCompleted(for trackerId: UUID, at date: Date) throws -> Bool? {
        return try recordStore.isCompleted(for: trackerId, at: date)
    }
    
    func count(at trackerId: UUID) throws -> Int {
        return try recordStore.count(at: trackerId)
    }
    
    // MARK: - Private func
    func transform(from coreDataObject: TrackerCoreData) throws -> Tracker {
        guard let id = coreDataObject.id,
              let name = coreDataObject.name,
              let hexColor = coreDataObject.color,
              let emoji = coreDataObject.emoji,
              let values = coreDataObject.schedule
        else { throw TrackerTransformError.transformErrorInvalidData }
        
        let schedule = values.compactMap { $0.wholeNumberValue }
        let color = UIColorMarshalling.color(from: hexColor)
        
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }
    
    func transform(from coreDataObject: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let header = coreDataObject.header else { throw  TrackerTransformError.transformErrorInvalidData }
        return TrackerCategory(header: header, trackers: [])
    }
}
