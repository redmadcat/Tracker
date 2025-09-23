//
//  TrackerWeekdayCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

import UIKit

final class TrackerWeekdayCell: UITableViewCell {
    // MARK: - Definition
    static let reuseIdentifier = "TrackerWeekdayCell"
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.onTintColor = .ypBlue
        toggleSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        return toggleSwitch
    }()
    
    private var index: Int = 0
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, index: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.index = index
        label.text = Calendar.weekday[safe: index]?.firstUppercased
                
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
        
        switch index {
        case 0:
            addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
            roundCorners(corners: [.topLeft, .topRight], radius: 16)
        case 6:
            roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
        default:
            addBorder(to: .bottom, width: 0.5, color: .ypGray, inset: 20)
        }
    }
    
    @objc private func changeSwitch() {
        print(toggleSwitch.isOn)
    //  delegate?.selectWeekDay(isON: weekDaySwitch.isOn, weekDay: weekDay)
    }
}
