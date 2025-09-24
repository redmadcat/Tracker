//
//  TrackerScheduleViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

import UIKit
import Foundation

final class TrackerScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
                                            TrackerWeekdayCellDelegate {
    // MARK: - Definition
    private lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerWeekdayCell.self, forCellReuseIdentifier: TrackerWeekdayCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("Готово", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = .ypBlack
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel(
            text: "Расписание",
            textColor: .ypBlack,
            font:.systemFont(ofSize: 16, weight: .medium),
            textAlighment: .center)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    private var selectedWeekday = [Int]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Calendar.weekday.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TrackerWeekdayCell(style: .default, reuseIdentifier: TrackerWeekdayCell.reuseIdentifier, index: indexPath.row, delegate: self)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
    // MARK: - TrackerWeekdayCellDelegate
    func weekdayCellDidTapLike(_ cell: TrackerWeekdayCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if cell.isWeekdaySelected {
            selectedWeekday.append(indexPath.row)
        } else {
            selectedWeekday = selectedWeekday.filter() { $0 != indexPath.row }
        }
        print(selectedWeekday.sorted { $0 < $1 })
    }
        
    // MARK: - Private func
    private func configureLayout() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.widthAnchor.constraint(equalToConstant: 133),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: createButton.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        view.backgroundColor = .ypWhite
    }
    
    @objc private func createButtonTapped() {
        dismiss(animated: true)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TrackerScheduleViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            TrackerScheduleViewController().toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
