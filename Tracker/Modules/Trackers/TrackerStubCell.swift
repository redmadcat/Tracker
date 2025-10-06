//
//  TrackerStubCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 24.09.2025.
//

import UIKit

final class TrackerStubCell: UITableViewCell {
    // MARK: - Definition
    private let warningLimitLabel = UILabel(
        text: "Ограничение 38 символов",
        textColor: .ypRed,
        font:.systemFont(ofSize: 17, weight: .regular),
        textAlighment: .center,
        isHidden: true)
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerStubCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(warningLimitLabel)
        
        NSLayoutConstraint.activate([
            warningLimitLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            warningLimitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            warningLimitLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWarning(_ value: Bool) {
        warningLimitLabel.isHidden = !value
    }
}
