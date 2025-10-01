//
//  TrackerScheduleViewController+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 01.10.2025.
//

extension TrackerScheduleViewController {
    func weekDayIndex(at index: Int) -> Int {
        switch index {
        case 0: return 1
        case 1: return 2
        case 2: return 3
        case 3: return 4
        case 4: return 5
        case 5: return 6
        default:
            return 0
        }
    }
}
