//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DomainDataLayer.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let tracker = TrackerRecordCoreData(context: context)
        tracker.trackerId = trackerRecord.trackerId
        tracker.date = trackerRecord.date
        try context.save()
    }
}
