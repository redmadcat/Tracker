//
//  TrackerCategoryMock.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 05.10.2025.
//

import Foundation

extension TrackerCategory {
    static let mock: [TrackerCategory] = [
        TrackerCategory(header: "Категория 1", trackers: [
            Tracker(id: UUID(), name: "Трекер 1.1", color: .ypSelection1, emoji: "🔥", schedule: [0, 1, 2]),
            Tracker(id: UUID(), name: "Трекер 1.2", color: .ypSelection2, emoji: "🎯", schedule: [3, 4, 5])
        ]),
        TrackerCategory(header: "Категория 2", trackers: [
            Tracker(id: UUID(), name: "Трекер 2.1", color: .ypSelection3, emoji: "💪", schedule: [4, 5]),
            Tracker(id: UUID(), name: "Трекер 2.2", color: .ypSelection4, emoji: "🌿", schedule: [2, 3])
        ]),
        TrackerCategory(header: "Категория 3", trackers: [
            Tracker(id: UUID(), name: "Трекер 3.1", color: .ypSelection5, emoji: "☀️", schedule: [3, 4]),
            Tracker(id: UUID(), name: "Трекер 3.2", color: .ypSelection6, emoji: "🌙", schedule: [2])
        ]),
        TrackerCategory(header: "Категория 4", trackers: [
            Tracker(id: UUID(), name: "Трекер 4.1", color: .ypSelection7, emoji: "📚", schedule: [0, 5]),
            Tracker(id: UUID(), name: "Трекер 4.2", color: .ypSelection8, emoji: "🧘", schedule: [0])
        ])
    ]
}
