//
//  TrackerRecordProtocol.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import Foundation

protocol TrackerRecordProtocol {
    func fetchTrackerRecords() throws -> [TrackerRecord]
    func addTrackerRecord(_ record: TrackerRecord) throws
    func isTrackerCompletedToday(_ id: UUID, _ date: Date) -> Bool
}
