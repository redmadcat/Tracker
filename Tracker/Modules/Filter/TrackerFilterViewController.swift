//
//  TrackerFilterViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 05.11.2025.
//

import UIKit

final class TrackerFilterViewController: TrackerTableViewController {
    private var indexPaths: [Int:Int] = [:]
    private let headerLabel = UILabel(
        text: "Фильтры",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 16, weight: .medium),
        textAlighment: .center)
    
    private let filters: [(index: Int, name: String)] = [
        (0, "Все трекеры"),
        (1, "Трекеры на сегодня"),
        (2, "Завершенные"),
        (3, "Не завершенные"),
    ]
            
    var onFilterSelected: ((Int) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    func setFilterAt(_ index: Int) {
        indexPaths = [0:index]
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = filters[indexPath.row]
        let cell = TrackerFilterCell()
        cell.configure(index: filter.index, name: filter.name)
        if indexPaths[indexPath.section] == indexPath.row {
            switch indexPath.row {
            case 0, 1:
                cell.accessoryType = .none
            default:
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
            
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    
        let selectedFilterRow = indexPaths[indexPath.section]
        if let previousCell = tableView.cellForRow(at: IndexPath(row: selectedFilterRow ?? 0, section: indexPath.section)) {
            previousCell.accessoryType = .none
        }

        indexPaths[indexPath.section] = indexPath.row
        if let cell = tableView.cellForRow(at: indexPath) {
            switch indexPath.row {
            case 0, 1:
                cell.accessoryType = .none
            default:
                cell.accessoryType = .checkmark
            }
            onFilterSelected?(indexPath.row)
            dismiss(animated: true)
        }
    }
    
    // MARK: - Private func
    private func configureUI() {
        // tableView
        tableView.register(TrackerFilterCell.self, forCellReuseIdentifier: TrackerFilterCell.reuseIdentifier)
        
        view.backgroundColor = .ypWhite
        
        // hierarchy
        view.addSubview(headerLabel)
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.widthAnchor.constraint(equalToConstant: 133),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

@available(iOS 17.0, *)
#Preview {
    TrackerFilterViewController()
}
