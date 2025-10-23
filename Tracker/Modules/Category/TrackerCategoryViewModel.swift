//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 22.10.2025.
//

import Foundation

final class TrackerCategoryViewModel {
    // MARK: - Definition
    lazy var rows: Int = categories.count
    private var dataProvider: TrackerDataProviderProtocol?
    private var categories: [TrackerCategory] = []
    
    // MARK: - Lifecycle
    init(provider dataProvider: TrackerDataProviderProtocol?) {
        self.dataProvider = dataProvider
        configureStartupData()
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        return categories[safe: indexPath.row]
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
