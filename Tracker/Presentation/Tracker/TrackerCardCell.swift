//
//  TrackerCardCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 24.09.2025.
//

import UIKit

final class TrackerCardCell: UICollectionViewCell {
    // MARK: - Definition
    let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .ypSelection5
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.ypBackgroundAlpha30.cgColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    let emojiFrame: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = 12
        stackView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🥹"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Some habbit"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.tintColor = .ypWhite
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypSelection5
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emojiFrame.addSubview(emojiLabel)
        cardStackView.addSubview(emojiFrame)
        cardStackView.addSubview(titleLabel)
                
        contentView.addSubview(cardStackView)
        contentView.addSubview(countLabel)
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            cardStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardStackView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiFrame.topAnchor.constraint(equalTo: cardStackView.topAnchor, constant: 12),
            emojiFrame.leadingAnchor.constraint(equalTo: cardStackView.leadingAnchor, constant: 12),
            emojiFrame.heightAnchor.constraint(equalToConstant: 24),
            emojiFrame.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiFrame.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiFrame.centerYAnchor),
                        
            titleLabel.leadingAnchor.constraint(equalTo: cardStackView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardStackView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardStackView.bottomAnchor, constant: -12),
                                    
            countLabel.topAnchor.constraint(equalTo: cardStackView.bottomAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
            countLabel.widthAnchor.constraint(equalToConstant: 101),
            
            completeButton.topAnchor.constraint(equalTo: cardStackView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
