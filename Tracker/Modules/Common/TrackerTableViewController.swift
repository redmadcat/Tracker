//
//  TrackerTableViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 22.10.2025.
//

import UIKit

class TrackerTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Definition
    private(set) lazy var tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
