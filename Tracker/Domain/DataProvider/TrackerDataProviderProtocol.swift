//
//  TrackerDataProviderProtocol.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import Foundation

protocol TrackerDataProviderProtocol {
    var delegate: TrackerDataProviderDelegate? { get set }
    var categories: [TrackerCategory] { get }
    func fetch() throws -> [TrackerCategory]?
    func add(_ category: TrackerCategory) throws
    func add(_ trackerRecord: TrackerRecord) throws
    func delete(_ trackerRecord: TrackerRecord) throws
    func isCompleted(for trackerId: UUID, at date: Date) throws -> Bool?
    func count(at trackerId: UUID) throws -> Int
}
