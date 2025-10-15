//
//  TrackerDataProviderProtocol.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

protocol TrackerDataProviderProtocol {
    var categories: [TrackerCategory] { get }
    func addTrackerCategory(_ category: TrackerCategory) throws
}
