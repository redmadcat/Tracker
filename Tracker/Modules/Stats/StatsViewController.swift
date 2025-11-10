//
//  StatsViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.09.2025.
//

import UIKit

final class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Definition
    private lazy var tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
    private lazy var titleLabel = UILabel()
    private lazy var stubStackView = UIStackView()

    private let stubLabel = UILabel(
        text: "Анализировать пока нечего",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 12, weight: .medium),
        textAlighment: .center)
    
    private let imageView = UIImageView()
    
    var statsArray: [(value: Int, name: String)] = []
    var recordStore: TrackerRecordStoreProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stats = statsArray[indexPath.row]
        let cell = StatsCell()
        cell.configure(value: String(stats.value), name: stats.name)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    // MARK: - Private func
    private func configureUI() {
        // titleLabel
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .ypBlack
        titleLabel.text = NSLocalizedString("title_stats", comment: "Stats title label")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatsCell.self, forCellReuseIdentifier: StatsCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // stubStackView
        stubStackView.distribution = .equalCentering
        stubStackView.axis = .vertical
        stubStackView.backgroundColor = .clear
        stubStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .emptyScreenLogo)
        
        view.backgroundColor = .ypWhite
        
        // hierarchy
        stubStackView.addSubview(imageView)
        stubStackView.addSubview(stubLabel)
        view.addSubview(stubStackView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            stubStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 70),
            stubStackView.heightAnchor.constraint(equalToConstant: 106),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stubLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: stubStackView.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: stubStackView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func reloadData() {
        statsArray.removeAll()
        if let count = try? recordStore?.completedCount(),
            count > 0 {
            statsArray.append((value: count, name: "Трекеров завершено"))
        }
        updateStubIsHiddenStatus()
    }
    
    private func updateStubIsHiddenStatus() {
        stubStackView.isHidden = statsArray.count > 0
    }
}

@available(iOS 17.0, *)
#Preview {
    StatsViewController()
}
