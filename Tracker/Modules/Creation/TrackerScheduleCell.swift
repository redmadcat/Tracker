//
//  TrackerScheduleCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerScheduleCell: UITableViewCell {
    // MARK: - Lifecycle
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerScheduleCell.reuseIdentifier, schedule: [Int]? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        textLabel?.text = "Расписание"
        textLabel?.textColor = .ypBlack
        detailTextLabel?.font = .systemFont(ofSize: 17)
        detailTextLabel?.textColor = .ypGray
        contentView.superview?.backgroundColor = .ypBackground
        if let schedule {
            setDetailsBased(on: schedule)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
    }
    
    func setDetailsBased(on selectedDays: [Int]) {
        detailTextLabel?.text = selectedDays.count == Calendar.weekdayCount ?
            "Каждый день" :
            Calendar.shortWeedaySymbols(at: selectedDays)
    }
}
