//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 21.10.2025.
//

import UIKit

final class TrackerCategoryViewController: TrackerTableViewController {
    // MARK: - Definition
    private var viewModel: TrackerCategoryViewModel?
    private var indexPaths: [Int:Int] = [:]
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
    
    var onCategorySelected: ((String, [Int:Int]) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        updateStubIsHiddenStatus()
    }
    
    func initialize(viewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    func setCategory(at indexPaths: [Int:Int]) {
        self.indexPaths = indexPaths
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCategoryEditableCell.reuseIdentifier, for: indexPath) as? TrackerCategoryEditableCell
        else { return UITableViewCell() }
                
        if let category = viewModel?.object(at: indexPath) {
            cell.configure(with: category.header)
            cell.accessoryType = indexPaths[indexPath.section] == indexPath.row ?
                .checkmark :
                .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.roundTopBottomCornersFor(tableView, with: cell, at: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
            
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    
        let selectedFilterRow = indexPaths[indexPath.section]
        if selectedFilterRow == indexPath.row {
            return
        }
        
        if let previousCell = tableView.cellForRow(at: IndexPath(row: selectedFilterRow ?? 0, section: indexPath.section)) {
            previousCell.accessoryType = .none
        }

        indexPaths[indexPath.section] = indexPath.row
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            if let category = cell.textLabel?.text {
                onCategorySelected?(category, indexPaths)
                dismiss(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            let editMenu = UIMenu(title: "", children: [
                UIAction(title: "Редактировать") { _ in
                    guard let category = self.viewModel?.object(at: indexPath) else { return }
                    let categoryEditingViewController = TrackerCategoryEditingViewController()
                    categoryEditingViewController.editWith(category)
                    categoryEditingViewController.onCategoryEdited = { categoryResult in
                        guard let viewModel = self.viewModel else { return }
                        if !viewModel.exists(categoryResult) {
                            viewModel.update(with: categoryResult, at: indexPath)
                        }
                    }
                    categoryEditingViewController.modalPresentationStyle = .pageSheet
                    self.present(categoryEditingViewController, animated: true, completion: nil)
                },
                UIAction(title: "Удалить", attributes: .destructive) { _ in
                    let deleteAlert = UIAlertController(title: "Эта категория точно не нужна?", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                    let removeAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                        self.viewModel?.remove(at: indexPath)
                        
                        let selectedRow = self.indexPaths[indexPath.section]
                        if selectedRow == indexPath.row {
                            self.onCategorySelected?("", self.indexPaths)
                        }
                    }

                    let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
                    deleteAlert.addAction(removeAction)
                    deleteAlert.addAction(cancelAction)
                    self.present(deleteAlert, animated: true, completion: nil)
                }
            ])
            return editMenu
        }
        return UIContextMenuConfiguration(identifier: "CategoryViewControllerContextMenu" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
    }
    
    // MARK: - Private func
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onDataSourceChange = { [weak self ] in
            self?.tableView.reloadData()
            self?.updateStubIsHiddenStatus()
        }
    }
    
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
        if let rows = viewModel?.count() {
            let isHidden = rows > 0 ? true : false
            stubStackView.isHidden = isHidden
        }
    }
    
    func add(_ category: TrackerCategory) {
        self.viewModel?.append(category)
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let categoryCreationViewController = TrackerCategoryCreationViewController()
        categoryCreationViewController.onCategoryCreated =  { category in
            guard let viewModel = self.viewModel else { return }
            if !viewModel.exists(category) {
                viewModel.append(category)
            }
        }
        categoryCreationViewController.modalPresentationStyle = .pageSheet
        present(categoryCreationViewController, animated: true, completion: nil)
    }
}

@available(iOS 17.0, *)
#Preview {
    TrackerCategoryViewController()
}
