//
//  PlaceView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class PlaceView: UIView {
    
    private lazy var placeBackgroundView = UIView()
    private lazy var placeTextField = UITextField()
    
    weak var delegate: PlaceViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.configureBackground()
        self.configureTextField()
    }
    
    private func configureBackground() {
        self.addSubview(self.placeBackgroundView)
        self.placeBackgroundView.backgroundColor = .systemBackground
        self.placeBackgroundView.layer.cornerRadius = 10
        
        self.placeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.placeBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.placeBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.placeBackgroundView.heightAnchor.constraint(equalToConstant: 45),
            self.placeBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        self.placeBackgroundView.addSubview(self.placeTextField)
        self.placeTextField.backgroundColor = .systemBackground
        if let color = UIColor(named: "LabelPurple") {
            self.placeTextField.attributedPlaceholder = NSAttributedString(string: "장소를 적어주세요", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
        self.placeTextField.delegate = self
        
        self.placeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeTextField.leftAnchor.constraint(equalTo: self.placeBackgroundView.leftAnchor, constant: 20),
            self.placeTextField.rightAnchor.constraint(equalTo: self.placeBackgroundView.rightAnchor, constant: -20),
            self.placeTextField.topAnchor.constraint(equalTo: self.placeBackgroundView.topAnchor),
            self.placeTextField.bottomAnchor.constraint(equalTo: self.placeBackgroundView.bottomAnchor)
        ])
    }
    
}

extension PlaceView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.delegate?.placeTextFieldDidReturn(text)
        }
        textField.resignFirstResponder()
        return true
    }
}

protocol PlaceViewDelegate: AnyObject {
    func placeTextFieldDidReturn(_: String)
}
