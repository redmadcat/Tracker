//
//  TrackerRecordDataProvider.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import Foundation
import CoreData

private enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidTrackerId
    case decodingErrorInvalidDate
}

final class TrackerRecordDataProvider: NSObject, TrackerRecordProtocol {
    // MARK: - Definition
    private let context: NSManagedObjectContext
    private let dataStore: TrackerRecordStore
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "trackerId", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(_ dataStore: TrackerRecordStore) throws {
        self.dataStore = dataStore
        self.context = DomainDataLayer.shared.context
    }
    
    // MARK: - TrackerRecordProtocol
    func fetchTrackerRecords() throws -> [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try self.transformToTrackerRecord(from: $0) })
        else { return [] }
        return records
    }
    
    func addTrackerRecord(_ record: TrackerRecord) throws {
        try? dataStore.addTrackerRecord(record)
    }
    
    func isTrackerCompletedToday(_ id: UUID, _ date: Date) -> Bool {
        let completedTrackers = try? fetchTrackerRecords()
        
        return completedTrackers?.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: date)
            return trackerRecord.trackerId == id && isSameDay
        } ?? false
    }
    
    // MARK: - Private func
    private func transformToTrackerRecord(from recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerId = recordCoreData.trackerId else {
            throw TrackerRecordStoreError.decodingErrorInvalidTrackerId
        }
        guard let date = recordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        return TrackerRecord(trackerId: trackerId, date: date)
    }
}
