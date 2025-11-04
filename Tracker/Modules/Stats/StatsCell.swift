//
//  StatsCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 04.11.2025.
//

import UIKit

final class StatsCell: UITableViewCell {
    // MARK: - Definition
    private let cellView = UIView()
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private lazy var valueLabel = UILabel()
    private lazy var nameLabel = UILabel()
                        
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = StatsCell.reuseIdentifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
        
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
    }
    
    func configure(value: String, name: String) {
        valueLabel.text = value
        nameLabel.text = name
    }
    
    // MARK: - Private func
    private func configureUI() {
        // cellView
        cellView.layer.cornerRadius = 16
        cellView.backgroundColor = .ypWhite
        
        // valueLabel
        valueLabel.textColor = .ypBlack
        valueLabel.font = .systemFont(ofSize: 34, weight: .bold)
        
        // nameLabel
        nameLabel.textColor = .ypBlack
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        // gradientLayer
        gradientLayer.colors = UIColorMarshalling.gradient
        gradientLayer.cornerRadius = 16
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // gradientView
        gradientView.layer.cornerRadius = 16
        
        selectionStyle = .none
        backgroundColor = .ypWhite
        
        [gradientView, cellView].forEach {
            contentView.addSubview($0)
        }
        
        [cellView, gradientView, valueLabel, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
                
        gradientView.layer.addSublayer(gradientLayer)
        
        [valueLabel, nameLabel].forEach {
            cellView.addSubview($0)
        }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            gradientView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: -1),
            gradientView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: -1),
            gradientView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 1),
            gradientView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 1),
            
            valueLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14),
            valueLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            
            nameLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12)
        ])
    }
}
