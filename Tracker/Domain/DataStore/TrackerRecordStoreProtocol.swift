//
//  TrackerRecordStoreProtocol.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 19.10.2025.
//

import Foundation

protocol TrackerRecordStoreProtocol {
    func add(_ trackerRecord: TrackerRecord) throws
    func delete(_ trackerRecord: TrackerRecord) throws
    func delete(trackerRecordAt id: UUID) throws
    func isCompleted(for trackerId: UUID, at date: Date) throws -> Bool?
    func count(at trackerId: UUID) throws -> Int
    func completedCount() throws -> Int
}
