//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 22.10.2025.
//

final class TrackerCategoryViewModel {
    // MARK: - Definition
    lazy var rows: Int = categories.count
    private var dataProvider: TrackerDataProviderProtocol?
    private var categories: [TrackerCategory] = []
    
    init(provider dataProvider: TrackerDataProviderProtocol?) {
        self.dataProvider = dataProvider
    }
}
