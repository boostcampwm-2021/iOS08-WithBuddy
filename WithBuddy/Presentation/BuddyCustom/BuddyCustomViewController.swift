//
//  BuddyCustomViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/10.
//

import UIKit

class BuddyCustomViewController: UIViewController {
    
    private var tempLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tempLabel)
        self.tempLabel.textColor = .black
        self.tempLabel.text = "버디 커스텀 화면입니다."
        self.view.addSubview(UILabel())
        
        self.tempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tempLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tempLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
}

extension BuddyCustomViewController: UITextFieldDelegate {
    
    private func checkLengthOfName(textField: UITextField!, maxLength: Int) {
        guard let text = textField.text else { return }
        if text.count > maxLength {
            textField.deleteBackward()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkLengthOfName(textField: textField, maxLength: 10)
    }
}
