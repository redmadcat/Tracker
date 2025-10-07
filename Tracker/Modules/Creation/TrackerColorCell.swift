//
//  TrackerColorCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 07.10.2025.
//

import UIKit

final class TrackerColorCell: UICollectionViewCell {
    // MARK: - Definition
    private let colorRect = UIView()
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
            contentView.layer.borderColor = isSelected ?
                colorRect.backgroundColor?.withAlphaComponent(0.3).cgColor :
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
        
    func configure(color: UIColor) {
        colorRect.backgroundColor = color
    }
    
    // MARK: - Private func
    private func configureUI() {
        // colorRect
        colorRect.backgroundColor = .clear
        colorRect.layer.cornerRadius = 8
        colorRect.translatesAutoresizingMaskIntoConstraints = false
        
        // hierarchy
        contentView.layer.cornerRadius = 16
        contentView.addSubview(colorRect)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            colorRect.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorRect.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorRect.widthAnchor.constraint(equalToConstant: 40),
            colorRect.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
