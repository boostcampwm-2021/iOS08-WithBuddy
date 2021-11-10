//
//  GatheringDetailViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/10.
//

import UIKit

class GatheringDetailViewController: UIViewController {

    private var tempLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.tempLabel)
        self.tempLabel.textColor = .black
        self.tempLabel.text = "모임 상세 화면입니다."
        self.view.addSubview(UILabel())
        
        self.tempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tempLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tempLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

}
