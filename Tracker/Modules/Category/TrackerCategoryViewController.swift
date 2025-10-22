//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 21.10.2025.
//

import UIKit

final class TrackerCategoryViewController: TrackerTableViewController {
    // MARK: - Definition
    var dataProvider: TrackerDataProviderProtocol?
    private lazy var categoryViewModel = TrackerCategoryViewModel(provider: self.dataProvider)
    private lazy var addButton = UIButton()
    private lazy var stubStackView = UIStackView()
    private let imageView = UIImageView()
    private let stubLabel = UILabel(
        text: "Привычки и события можно объединять по смыслу",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 12, weight: .medium),
        textAlighment: .center)
    
    private let headerLabel = UILabel(
        text: "Категория",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 16, weight: .medium),
        textAlighment: .center)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewModel.rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TrackerCategoryEditableCell()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // MARK: - Private func
    private func configureUI() {
        // tableView
        tableView.register(TrackerCategoryEditableCell.self, forCellReuseIdentifier: TrackerCategoryEditableCell.reuseIdentifier)
        
        // addButton
        addButton.setTitle("Добавить категорию", for: .normal)
        addButton.setTitleColor(.ypWhite, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.backgroundColor = .ypBlack
        addButton.layer.cornerRadius = 16
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        // stubStackView
        stubStackView.distribution = .equalCentering
        stubStackView.axis = .vertical
        stubStackView.backgroundColor = .clear
        stubStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "DizzyScreenLogo")
        
        // stubLabel
        stubLabel.numberOfLines = 2
        
        view.backgroundColor = .ypWhite
        
        // hierarchy
        stubStackView.addSubview(imageView)
        stubStackView.addSubview(stubLabel)
        view.addSubview(headerLabel)
        view.addSubview(stubStackView)
        view.addSubview(addButton)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.widthAnchor.constraint(equalToConstant: 133),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stubStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubStackView.heightAnchor.constraint(equalToConstant: 106),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stubLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: stubStackView.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: stubStackView.trailingAnchor, constant: -16),
            stubLabel.widthAnchor.constraint(equalToConstant: 200),
                        
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateStubIsHiddenStatus() {
        let isHidden = categoryViewModel.rows > 0 ? true : false
        stubStackView.isHidden = isHidden
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        
    }
}

@available(iOS 17.0, *)
#Preview {
    TrackerCategoryViewController()
}
