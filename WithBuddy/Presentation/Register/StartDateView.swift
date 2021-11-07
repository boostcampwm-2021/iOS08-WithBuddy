//
//  StartDateView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class StartDateView: UIView {
    
    private lazy var dateTitleLabel = UILabel()
    private lazy var dateBackgroundView = UIView()
    private lazy var dateLabel = UILabel()
    private lazy var dateButton = UIButton()
    
    private var cancellables: Set<AnyCancellable> = []
    var registerViewModel: RegisterViewModel?
    var delegate: StartDateViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func bind(_ registerViewModel: RegisterViewModel) {
        self.registerViewModel = registerViewModel
        self.registerViewModel?.$startDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.dateLabel.text = date
            }
            .store(in: &self.cancellables)
    }
    
    private func configure() {
        self.configureTitleLabel()
        self.configureBackground()
        self.configureLabel()
        self.configureButton()
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.dateTitleLabel)
        self.dateTitleLabel.text = "모임 날짜"
        self.dateTitleLabel.textColor = UIColor(named: "LabelPurple")
        self.dateTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        self.dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.dateTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
    
    private func configureBackground() {
        self.addSubview(self.dateBackgroundView)
        self.dateBackgroundView.backgroundColor = .systemBackground
        self.dateBackgroundView.layer.cornerRadius = 10
        
        self.dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateBackgroundView.topAnchor.constraint(equalTo: self.dateTitleLabel.bottomAnchor, constant: 10),
            self.dateBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.dateBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.dateBackgroundView.heightAnchor.constraint(equalToConstant: 45),
            self.dateBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureLabel() {
        self.dateBackgroundView.addSubview(self.dateLabel)
        
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateLabel.leftAnchor.constraint(equalTo: self.dateBackgroundView.leftAnchor, constant: 20),
            self.dateLabel.centerYAnchor.constraint(equalTo: self.dateBackgroundView.centerYAnchor)
        ])
    }
    
    private func configureButton() {
        self.dateBackgroundView.addSubview(self.dateButton)
        self.dateButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        self.dateButton.sizeToFit()
        self.dateButton.addTarget(self, action: #selector(self.onDateButtonTouched(_:)), for: .touchUpInside)
        
        self.dateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateButton.rightAnchor.constraint(equalTo: self.dateBackgroundView.rightAnchor, constant: -20),
            self.dateButton.centerYAnchor.constraint(equalTo: self.dateBackgroundView.centerYAnchor)
        ])
    }
    
    @objc private func onDateButtonTouched(_ sender: UIButton) {
        self.delegate?.onStartDateButtonTouched()
    }
}

protocol StartDateViewDelegate {
    func onStartDateButtonTouched()
}
