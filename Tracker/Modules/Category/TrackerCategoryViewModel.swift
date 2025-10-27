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
    private var categories: [TrackerCategory] = []
    
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
    
    func exists(_ category: TrackerCategory) -> Bool {
        return categories.contains(where: { $0.header == category.header })
    }
    
    func update(with category: TrackerCategory, at indexPath: IndexPath) {
        if let oldCategory = object(at: indexPath) {
            self.categories = self.categories.map({ $0.header == oldCategory.header ? category : $0 })
            try? dataProvider?.update(oldCategory, with: category.header)
        }
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
