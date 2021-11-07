//
//  RegisterViewController.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/01.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var dateView = DateView()
    private lazy var placeView = PlaceView()
    private lazy var typeView = TypeView()
    private lazy var buddyView = BuddyView()
    private lazy var memoView = MemoView()
    private lazy var pictureView = PictureView()
    
    private var registerViewModel = RegisterViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.backgroundColor = .white
        return datePicker
    }()
        
    private lazy var toolBar : UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneTouched))]
        toolBar.sizeToFit()
        return toolBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        
        self.configureScrollView()
        self.configureContentView()
        self.configureDateView()
        self.configurePlaceView()
        self.configureTypeView()
        self.configureBuddyView()
        self.configureMemoView()
        self.configurePictureView()
        
        self.registerViewModel.didDatePicked(Date())
    }
    
    private func configureScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func configureContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapEmptySpace)))
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func configureDateView() {
        self.contentView.addSubview(self.dateView)
        self.dateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.dateView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.dateView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.dateView.delegate = self
        self.dateView.bind(self.registerViewModel)
    }
    
    private func configurePlaceView() {
        self.contentView.addSubview(self.placeView)
        self.placeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 40),
            self.placeView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.placeView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.placeView.bind(self.registerViewModel)
    }
    
    private func configureTypeView() {
        self.contentView.addSubview(self.typeView)
        self.typeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeView.topAnchor.constraint(equalTo: self.placeView.bottomAnchor, constant: 40),
            self.typeView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.typeView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.typeView.bind(self.registerViewModel)
    }
    
    private func configureBuddyView() {
        self.contentView.addSubview(self.buddyView)
        self.buddyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyView.topAnchor.constraint(equalTo: self.typeView.bottomAnchor, constant: 40),
            self.buddyView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.buddyView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.buddyView.bind(self.registerViewModel)
    }
    
    private func configureMemoView() {
        self.contentView.addSubview(self.memoView)
        self.memoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoView.topAnchor.constraint(equalTo: self.buddyView.bottomAnchor, constant: 40),
            self.memoView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.memoView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.memoView.bind(self.registerViewModel)
    }
    
    private func configurePictureView() {
        self.contentView.addSubview(self.pictureView)
        self.pictureView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureView.topAnchor.constraint(equalTo: self.memoView.bottomAnchor, constant: 40),
            self.pictureView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.pictureView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.pictureView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        self.pictureView.delegate = self
        self.pictureView.bind(self.registerViewModel)
    }
    
    @objc private func onDoneTouched() {
        self.registerViewModel.didDatePicked(self.datePicker.date)
        self.datePicker.removeFromSuperview()
        self.toolBar.removeFromSuperview()
    }

    @objc private func tapEmptySpace(){
        self.view.endEditing(true)
    }
}

extension RegisterViewController: DateViewDelegate {
    func onDateButtonTouched() {
        self.view.addSubview(self.datePicker)
        self.view.addSubview(self.toolBar)
                
        NSLayoutConstraint.activate([
            self.datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.datePicker.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            self.toolBar.bottomAnchor.constraint(equalTo: self.datePicker.topAnchor),
            self.toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension RegisterViewController: PictureViewDelegate {
    func onPictureButtonTouched() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let url = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return
        }
        self.registerViewModel.didPicturePicked(url)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
