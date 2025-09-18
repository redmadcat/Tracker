//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    
    private let headerLabel: UILabel = {
        return UILabel(
        text: "Новая привычка",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 16, weight: .medium),
        textAlighment: .center)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configureLayout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    private func configureLayout() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray
        
        view.addSubview(headerLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.widthAnchor.constraint(equalToConstant: 133),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300)
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
