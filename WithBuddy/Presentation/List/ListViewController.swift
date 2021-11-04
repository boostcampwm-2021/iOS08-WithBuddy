//
//  ListViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit

final class ListViewController: UIViewController {
    
    private let searchView = SearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.configureSearchView()
    }
    
    private func configureSearchView() {
        self.view.addSubview(self.searchView)
        self.searchView.layer.cornerRadius = 10
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.searchView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

}
