//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 22.10.2025.
//

import Foundation

final class TrackerCategoryViewModel {
    // MARK: - Definition
    private var dataProvider: TrackerDataProviderProtocol?
    var categories: [TrackerCategory] = []
    
    // MARK: - Lifecycle
    init(provider dataProvider: TrackerDataProviderProtocol?) {
        self.dataProvider = dataProvider
        configureStartupData()
    }
    
    func count() -> Int {
        return categories.count
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        return categories[safe: indexPath.row]
    }
    
    func remove(at indexPath: IndexPath) {
        let category = categories.remove(at: indexPath.row)
        try? dataProvider?.delete(category)
    }
    
    func append(_ category: TrackerCategory) {
        categories.append(category)
        try? dataProvider?.add(category)
    }
        
    // MARK: - Private func
    private func configureStartupData() {
        do {
            if let result = try dataProvider?.fetch() {
                categories = result
            }
        } catch {
            print("Cannot load data")
        }
    }
}
