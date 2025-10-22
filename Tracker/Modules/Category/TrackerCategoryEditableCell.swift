//
//  TrackerCategoryEditableCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 22.10.2025.
//

import UIKit

final class TrackerCategoryEditableCell: UITableViewCell {
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerCategoryEditableCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .checkmark
        
        textLabel?.text = "Важное"
        textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .ypBlack
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let label = textLabel {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
                
        contentView.superview?.backgroundColor = .ypBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
