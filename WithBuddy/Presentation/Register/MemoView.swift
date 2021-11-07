//
//  MemoView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class MemoView: UIView {

    private lazy var memoTitleLabel = UILabel()
    private lazy var memoBackgroundView = UIView()
    private lazy var memoTextField = UITextField()
   
    private var cancellables: Set<AnyCancellable> = []
    var registerViewModel: RegisterViewModel?
    
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
    }
    
    private func configure() {
        self.configureTitleLabel()
        self.configureBackground()
        self.configureTextField()
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.memoTitleLabel)
        self.memoTitleLabel.text = "메모"
        self.memoTitleLabel.textColor = UIColor(named: "LabelPurple")
        self.memoTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        self.memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.memoTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
    
    private func configureBackground() {
        self.addSubview(self.memoBackgroundView)
        self.memoBackgroundView.backgroundColor = .systemBackground
        self.memoBackgroundView.layer.cornerRadius = 10
        
        self.memoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoBackgroundView.topAnchor.constraint(equalTo: self.memoTitleLabel.bottomAnchor, constant: 20),
            self.memoBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.memoBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.memoBackgroundView.heightAnchor.constraint(equalToConstant: 140),
            self.memoBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        self.memoBackgroundView.addSubview(self.memoTextField)
        self.memoTextField.backgroundColor = .systemBackground
        if let color = UIColor(named: "LabelPurple") {
            self.memoTextField.attributedPlaceholder = NSAttributedString(string: "간단한 메모를 남겨보아요", attributes: [NSAttributedString.Key.foregroundColor : color])
        }
        self.memoTextField.delegate = self
        
        self.memoTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTextField.topAnchor.constraint(equalTo: self.memoBackgroundView.topAnchor),
            self.memoTextField.leftAnchor.constraint(equalTo: self.memoBackgroundView.leftAnchor, constant: 20),
            self.memoTextField.rightAnchor.constraint(equalTo: self.memoBackgroundView.rightAnchor, constant: -20),
            self.memoTextField.bottomAnchor.constraint(equalTo: self.memoBackgroundView.bottomAnchor)
        ])
    }
}

extension MemoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.registerViewModel?.didPlaceFinished(text)
        }
        textField.resignFirstResponder()
        return true
    }
}
