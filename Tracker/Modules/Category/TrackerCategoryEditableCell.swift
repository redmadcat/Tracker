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
        selectionStyle = .none
                
        if let label = textLabel {
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = .ypBlack
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
        contentView.superview?.backgroundColor = .ypBackground
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    public func configure(with text: String) {
        textLabel?.text = text
    }
}
