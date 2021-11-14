//
//  TitleView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/14.
//

import UIKit

final class TitleView: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(text: String) {
        self.init()
        self.text = text
        self.textColor = UIColor(named: "LabelPurple")
        self.font = .boldSystemFont(ofSize: 20)
    }

}
