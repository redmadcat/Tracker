//
//  TrackerCardCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 24.09.2025.
//

import UIKit

final class TrackerCardCell: UICollectionViewCell {
    // MARK: - Definition    
    weak var delegate: TrackerCardCellDelegate?
    
    private let cardStackView = UIStackView()
    private let emojiFrame = UIStackView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private lazy var completeButton = UIButton()
    
    private var isCompletedToday = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker, daysCounter counter: Int, completion isCompletedToday: Bool, date selectedDate: Date, at indexPath: IndexPath) {
        trackerId = tracker.id
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        countLabel.text = counter.daysWordForm
                    
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
                
        let image = isCompletedToday ?
            UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)) :
            UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
        cardStackView.backgroundColor = tracker.color
        completeButton.backgroundColor = tracker.color
        completeButton.setImage(image, for: .normal)
        completeButton.isEnabled = selectedDate.isLessThan(date: Date(), granularity: .day)
    }
    
    // MARK: - Private func
    private func configureUI() {
        // cardStackView
        cardStackView.axis = .horizontal
        cardStackView.layer.cornerRadius = 16
        cardStackView.layer.borderWidth = 1
        cardStackView.layer.borderColor = UIColor.ypBackgroundAlpha30.cgColor
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // emojiFrame
        emojiFrame.layer.cornerRadius = 12
        emojiFrame.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        emojiFrame.distribution = .equalCentering
        emojiFrame.translatesAutoresizingMaskIntoConstraints = false
        
        // emojiLabel
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // titleLabel
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .ypWhite
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // countLabel
        countLabel.font = .systemFont(ofSize: 12, weight: .medium)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // completeButton
        completeButton.layer.cornerRadius = 17
        completeButton.tintColor = .ypWhite
        completeButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // hierarchy
        emojiFrame.addSubview(emojiLabel)
        cardStackView.addSubview(emojiFrame)
        cardStackView.addSubview(titleLabel)
        contentView.addSubview(cardStackView)
        contentView.addSubview(countLabel)
        contentView.addSubview(completeButton)
    }
    
    private func configureLayout() {
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
    
    // MARK: - Actions
    @objc private func completionButtonTapped() {
        guard let trackerId, let indexPath else { return }
        delegate?.setCompletionTo(completion: isCompletedToday, with: trackerId, at: indexPath)
    }
}
