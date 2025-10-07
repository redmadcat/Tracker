//
//  TrackerEmojiCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 07.10.2025.
//

import UIKit

final class TrackerEmojiCell: UICollectionViewCell {
    // MARK: - Definition
    private let label = UILabel()
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.backgroundColor = isSelected ?
                UIColor.ypLightGray.cgColor :
                UIColor.clear.cgColor
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        label.text = text
    }
    
    // MARK: - Private func
    private func configureUI() {
        // label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // hierarchy
        contentView.layer.cornerRadius = 16
        contentView.addSubview(label)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
