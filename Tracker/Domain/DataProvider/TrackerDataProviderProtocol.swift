//
//  TrackerDataProviderProtocol.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

protocol TrackerDataProviderProtocol {
    var numberOfSections: Int { get }
    var categories: [TrackerCategory] { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func addTrackerCategory(_ category: TrackerCategory) throws
}
