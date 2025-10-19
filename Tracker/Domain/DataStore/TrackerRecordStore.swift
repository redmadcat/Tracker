//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.10.2025.
//

import CoreData

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    // MARK: - Definition
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = DomainDataLayer.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - TrackerRecordStoreProtocol
    func add(_ trackerRecord: TrackerRecord) throws {
        let tracker = TrackerRecordCoreData(context: context)
        tracker.trackerId = trackerRecord.trackerId
        tracker.date = trackerRecord.date
        try context.save()
    }
    
    func delete(_ trackerRecord: TrackerRecord) throws {
        guard let (from, to) = Calendar.range(for: trackerRecord.date) else { return }
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "trackerId == %@ AND (date >= %@ AND date < %@)",
                                        trackerRecord.trackerId as CVarArg, from as CVarArg, to as CVarArg)
        
        if let record = try! context.fetch(request).first {
            context.delete(record)
            try context.save()
        }
    }
    
    func isCompleted(for trackerId: UUID, at date: Date) throws -> Bool? {
        guard let (from, to) = Calendar.range(for: date) else { return nil }
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@ AND (date >= %@ AND date < %@)",
            #keyPath(TrackerRecordCoreData.trackerId), trackerId as CVarArg,
            from as CVarArg, to as CVarArg)

        return try context.count(for: request) > 0 ? true : false
    }
    
    func count(at trackerId: UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), trackerId as CVarArg)
        
        return try! context.count(for: request)
    }
}
