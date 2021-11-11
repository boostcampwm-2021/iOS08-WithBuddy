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
    private lazy var memoTextView = UITextView()
   
    weak var delegate: MemoViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
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
        self.memoBackgroundView.addSubview(self.memoTextView)
        self.memoTextView.backgroundColor = .systemBackground
        self.memoTextView.font =  UIFont.systemFont(ofSize: 15, weight: .medium)
        self.memoTextView.textContentType = .none
        self.memoTextView.autocapitalizationType = .none
        self.memoTextView.autocorrectionType = .no
        self.memoTextView.delegate = self
        self.memoTextView.text = "메모를 적어주세요."
        self.memoTextView.textColor = UIColor(named: "LabelPurple")
        
        self.memoTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTextView.topAnchor.constraint(equalTo: self.memoBackgroundView.topAnchor, constant: 20),
            self.memoTextView.leftAnchor.constraint(equalTo: self.memoBackgroundView.leftAnchor, constant: 20),
            self.memoTextView.rightAnchor.constraint(equalTo: self.memoBackgroundView.rightAnchor, constant: -20),
            self.memoTextView.bottomAnchor.constraint(equalTo: self.memoBackgroundView.bottomAnchor, constant: -20)
        ])
    }
}

extension MemoView: UITextViewDelegate {
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.delegate?.memoTextFieldDidReturn(text)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "LabelPurple") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모를 적어주세요."
            textView.textColor = UIColor(named: "LabelPurple")
        }
    }

}

protocol MemoViewDelegate: AnyObject {
    func memoTextFieldDidReturn(_: String)
}
