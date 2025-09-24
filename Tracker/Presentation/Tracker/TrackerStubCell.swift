//
//  TrackerStubCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 24.09.2025.
//

import UIKit

final class TrackerStubCell: UITableViewCell {
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerStubCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
