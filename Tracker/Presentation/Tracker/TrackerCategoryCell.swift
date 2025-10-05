//
//  TrackerCategoryCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerCategoryCell: UITableViewCell {
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerCategoryCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        textLabel?.text = "Категория"
        textLabel?.textColor = .ypBlack
        detailTextLabel?.font = .systemFont(ofSize: 17)
        detailTextLabel?.textColor = .ypGray
        contentView.superview?.backgroundColor = .ypBackground
        addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
}
