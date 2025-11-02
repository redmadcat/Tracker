//
//  TrackerCategoryCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerCategoryCell: UITableViewCell {
    // MARK: - Lifecycle
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerCategoryCell.reuseIdentifier, categoryHeader: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        textLabel?.text = "Категория"
        detailTextLabel?.text = categoryHeader
        textLabel?.textColor = .ypBlack
        detailTextLabel?.font = .systemFont(ofSize: 17)
        detailTextLabel?.textColor = .ypGray
        contentView.superview?.backgroundColor = .ypBackground
        addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
}
