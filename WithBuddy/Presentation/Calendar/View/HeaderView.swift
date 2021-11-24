//
//  HeaderView.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import UIKit

class HeaderView: UIView {
    
    private let userFaceImageView = UIImageView()
    private let userCommentLabel = PurpleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureHeaderContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureHeaderContent()
    }
    
    func update(face: String) {
        self.userFaceImageView.image = UIImage(named: face)
    }
    
    private func configureHeaderContent() {
        self.configureUserFaceImageView()
        self.configureUserCommentLabel()
    }
    
    private func configureUserFaceImageView() {
        self.addSubview(userFaceImageView)
        self.userFaceImageView.image = UIImage(named: BuddyUseCase(coreDataManager: CoreDataManager.shared).makeRandomBuddy().face)
        self.userFaceImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userFaceImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.userFaceImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.userFaceImageView.widthAnchor.constraint(equalToConstant: 70),
            self.userFaceImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func configureUserCommentLabel() {
        guard let userInfo = UserUseCase().fetchUser() else { return }
        self.addSubview(userCommentLabel)
        self.userCommentLabel.numberOfLines = 0
        self.userCommentLabel.text = "\(userInfo.name)님! 안녕하세요!\n친구와의 만남을 기록하고 편하게 관리해보아요!"
        self.userCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userCommentLabel.leadingAnchor.constraint(equalTo: self.userFaceImageView.trailingAnchor, constant: 10),
            self.userCommentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.userCommentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.userCommentLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}
