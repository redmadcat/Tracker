//
//  TrackerFilterCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 05.11.2025.
//

import UIKit

final class TrackerFilterCell: UITableViewCell {
    private var index: Int?
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerFilterCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch index {
        case 0:
            roundCorners(corners: [.topLeft, .topRight], radius: 16)
            addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
        case 3:
            roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
        default:
            addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
        }
    }
    
    func configure(index: Int, name: String) {
        self.index = index
        textLabel?.text = name
    }
    
    // MARK: - Private func
    private func configureUI() {
        if let label = textLabel {
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = .ypBlack
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
        selectionStyle = .none
        contentView.superview?.backgroundColor = .ypBackground
    }
}
