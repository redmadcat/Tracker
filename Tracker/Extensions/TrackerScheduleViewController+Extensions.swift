//
//  TrackerScheduleViewController+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 01.10.2025.
//

extension TrackerScheduleViewController {
    func weekDayIndex(at index: Int) -> Int {
        return index < 6 ? index + 1 : 0
    }
}
