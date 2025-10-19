//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 19.10.2025.
//

protocol TrackerStoreProtocol {
    func fetch() -> [TrackerCoreData]?
    func add(_ tracker: Tracker, category: TrackerCategoryCoreData) throws
}
