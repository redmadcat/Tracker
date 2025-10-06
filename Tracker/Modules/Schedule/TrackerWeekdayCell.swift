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
    
    private lazy var toggleSwitch = UISwitch()
    private let label = UILabel()
    
    var dayIndex: Int = 0
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerWeekdayCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // MARK: - Private func
    private func configureUI() {
        // toggleSwitch
        toggleSwitch.onTintColor = .ypBlue
        toggleSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        // label
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        selectionStyle = .none
        contentView.superview?.backgroundColor = .ypBackground
        
        // hierarchy
        contentView.addSubview(label)
        contentView.addSubview(toggleSwitch)                
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func changeSwitch() {
        delegate?.weekdayCellDidTapLike(self, isOn: toggleSwitch.isOn)
    }
}
