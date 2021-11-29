//
//  SearchView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import UIKit

final class SearchView: UIView {
    
    private let searchButton = UIButton()
    private(set) var searchTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func reset() {
        self.searchTextField.text = ""
    }
    
    private func configure() {
        self.backgroundColor = .systemBackground
        self.configureButton()
        self.configureTextField()
    }
    
    private func configureButton() {
        self.addSubview(self.searchButton)
        self.searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            self.searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.searchButton.heightAnchor.constraint(equalToConstant: 44),
            self.searchButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureTextField() {
        self.addSubview(self.searchTextField)
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "버디를 검색해 보아요.", attributes: [.foregroundColor: .labelPurple ?? UIColor.systemPurple])
        self.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchTextField.leadingAnchor.constraint(equalTo: self.searchButton.trailingAnchor, constant: 4),
            self.searchTextField.centerYAnchor.constraint(equalTo: self.searchButton.centerYAnchor),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

}
