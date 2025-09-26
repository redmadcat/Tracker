//
//  TrackerWeekdayCellDelegate.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

protocol TrackerWeekdayCellDelegate: AnyObject {
    func weekdayCellDidTapLike(_ cell: TrackerWeekdayCell, isOn: Bool)
}
