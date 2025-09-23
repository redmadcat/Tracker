//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Definition
    private lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(TrackerNameCell.self, forCellReuseIdentifier: TrackerNameCell.reuseIdentifier)
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.reuseIdentifier)
        tableView.register(TrackerScheduleCell.self, forCellReuseIdentifier: TrackerScheduleCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var footerView: UIStackView = {
        let footerView = UIStackView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(cancelButton)
        footerView.addSubview(createButton)
        return footerView
    }()
    
    private var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.backgroundColor = .ypBlack
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel(
            text: "Новая привычка",
            textColor: .ypBlack,
            font:.systemFont(ofSize: 16, weight: .medium),
            textAlighment: .center)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                                                
        configureLayout()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return indexPath.row == 0 ?
                TrackerNameCell(style: .default, reuseIdentifier: TrackerNameCell.reuseIdentifier) :
                UITableViewCell()
        case 1:
            return indexPath.row == 0 ?
                TrackerCategoryCell(style: .subtitle, reuseIdentifier: TrackerCategoryCell.reuseIdentifier) :
                TrackerScheduleCell(style: .subtitle, reuseIdentifier: TrackerScheduleCell.reuseIdentifier)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return indexPath.row == 0 ? 75 : 24
        case 1:
            return indexPath.row == 0 || indexPath.row == 1 ? 75 : 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let scheduleViewController = TrackerScheduleViewController()
                scheduleViewController.modalPresentationStyle = .pageSheet
                present(scheduleViewController, animated: true, completion: nil)
            }
        }
    }
        
    // MARK: - Private func
    private func configureLayout() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.widthAnchor.constraint(equalToConstant: 133),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            cancelButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            createButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8)
        ])
        
        view.backgroundColor = .ypWhite
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TrackerCreationViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            TrackerCreationViewController().toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
