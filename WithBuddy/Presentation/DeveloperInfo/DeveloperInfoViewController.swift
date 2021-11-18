//
//  DeveloperInfoViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/16.
//

import UIKit

class DeveloperInfoViewController: UIViewController {

    private var tempLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tempLabel)
        self.tempLabel.textColor = .black
        self.tempLabel.text = "개발자 정보 화면입니다."
        self.view.addSubview(UILabel())
        
        self.tempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tempLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tempLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

}
