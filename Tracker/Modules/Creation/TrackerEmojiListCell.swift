//
//  TrackerEmojiListCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 07.10.2025.
//

import UIKit
    
final class TrackerEmojiListCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // MARK: - Definition
    private weak var delegate: TrackerCreationViewController?
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var selectedEmoji: String?
    
    private var emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    
    // MARK: - Lifecycle
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerEmojiListCell.reuseIdentifier, delegate: TrackerCreationViewController?, emoji: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.delegate = delegate
        selectedEmoji = emoji
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerEmojiCell.reuseIdentifier, for: indexPath) as? TrackerEmojiCell else { return UICollectionViewCell() }
        
        let emoji = emojis[indexPath.row]
        cell.configure(text: emoji)
        
        if selectedEmoji == emoji {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderView.reuseIdentifier,
            for: indexPath) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        header.setHeader(with: "Emoji")
        return header
    }
        
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 25) / 6
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEmoji = emojis[indexPath.row]
        delegate?.setEmoji(selectedEmoji)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerEmojiCell {
            cell.isSelected = false
        }
    }
    
    // MARK: - Private func
    private func configureUI() {
        // collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerEmojiCell.self, forCellWithReuseIdentifier: TrackerEmojiCell.reuseIdentifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // hierarchy
        contentView.addSubview(collectionView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
