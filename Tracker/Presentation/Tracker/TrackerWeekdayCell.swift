//
//  TrackerWeekdayCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

import UIKit

final class TrackerWeekdayCell: UITableViewCell {
    // MARK: - Definition
    weak var delegate: TrackerWeekdayCellDelegate?
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.onTintColor = .ypBlue
        toggleSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        return toggleSwitch
    }()
        
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dayIndex: Int = 0
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerWeekdayCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.superview?.backgroundColor = .ypBackground
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch dayIndex {
        case 1:
            addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
            roundCorners(corners: [.topLeft, .topRight], radius: 16)
        case 0:
            roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
        default:
            addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
        }
    }
    
    func configure(index: Int, delegate: TrackerWeekdayCellDelegate, isOn: Bool) {
        self.delegate = delegate
        self.dayIndex = index
        toggleSwitch.isOn = isOn
        label.text = Calendar.weekdaySymbol(at: index)
    }
    
    @objc private func changeSwitch() {
        delegate?.weekdayCellDidTapLike(self, isOn: toggleSwitch.isOn)
    }
}
