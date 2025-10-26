//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 19.10.2025.
//

protocol TrackerCategoryStoreProtocol {
    func add(_ trackerCategory: TrackerCategory) throws -> TrackerCategoryCoreData
    func delete(_ trackerCategory: TrackerCategory) throws
    func fetch() throws -> [TrackerCategoryCoreData]?
}
