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
    
    private lazy var startDateView = StartDateView()
    private lazy var endDateView = EndDateView()
    private lazy var placeView = PlaceView()
    private lazy var typeView = TypeView()
    private lazy var buddyView = BuddyView()
    private lazy var memoView = MemoView()
    private lazy var pictureView = PictureView()
    
    private lazy var datePicker = UIDatePicker()
    private lazy var dateToolBar = UIToolbar()
    
    private var registerViewModel = RegisterViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configure()
        self.registerViewModel.didStartDatePicked(Date())
        self.registerViewModel.didEndDatePicked(Date())
    }
    
    private func bind() {
        self.registerViewModel.$startDateString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.startDateView.changeDateLebelText(date)
            }
            .store(in: &self.cancellables)
        
        self.registerViewModel.$endDateString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.endDateView.changeDateLebelText(date)
            }
            .store(in: &self.cancellables)
        
        self.registerViewModel.$typeSelectedList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] typeSelectedList in
                self?.typeView.changeSelectedType(typeSelectedList)
            }
            .store(in: &self.cancellables)
        
        self.registerViewModel.$buddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                self?.buddyView.buddyListReload(buddyList)
            }
            .store(in: &self.cancellables)
        
        
        self.registerViewModel.$pictures
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pictures in
                self?.pictureView.pictureListReload(pictures)
            }
            .store(in: &self.cancellables)
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        
        self.configureScrollView()
        self.configureContentView()
        self.configureStartDateView()
        self.configureEndDateView()
        self.configurePlaceView()
        self.configureTypeView()
        self.configureBuddyView()
        self.configureMemoView()
        self.configurePictureView()
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
 
    private func configureStartDateView() {
        self.contentView.addSubview(self.startDateView)
        self.startDateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.startDateView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.startDateView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.startDateView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.startDateView.delegate = self
    }
    
    private func configureEndDateView() {
        self.contentView.addSubview(self.endDateView)
        self.endDateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.endDateView.topAnchor.constraint(equalTo: self.startDateView.bottomAnchor, constant: 40),
            self.endDateView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.endDateView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.endDateView.delegate = self
    }
    
    private func configurePlaceView() {
        self.contentView.addSubview(self.placeView)
        self.placeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeView.topAnchor.constraint(equalTo: self.endDateView.bottomAnchor, constant: 40),
            self.placeView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.placeView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.placeView.delegate = self
    }
    
    private func configureTypeView() {
        self.contentView.addSubview(self.typeView)
        self.typeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeView.topAnchor.constraint(equalTo: self.placeView.bottomAnchor, constant: 40),
            self.typeView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.typeView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.typeView.delegate = self
    }
    
    private func configureBuddyView() {
        self.contentView.addSubview(self.buddyView)
        self.buddyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyView.topAnchor.constraint(equalTo: self.typeView.bottomAnchor, constant: 40),
            self.buddyView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.buddyView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.buddyView.delegate = self
    }
    
    private func configureMemoView() {
        self.contentView.addSubview(self.memoView)
        self.memoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoView.topAnchor.constraint(equalTo: self.buddyView.bottomAnchor, constant: 40),
            self.memoView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.memoView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
        ])
        self.memoView.delegate = self
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
    }
    
    @objc private func onStartDoneTouched() {
        self.registerViewModel.didStartDatePicked(self.datePicker.date)
        self.datePicker.removeFromSuperview()
        self.dateToolBar.removeFromSuperview()
    }
    
    @objc private func onEndDoneTouched() {
        self.registerViewModel.didEndDatePicked(self.datePicker.date)
        self.datePicker.removeFromSuperview()
        self.dateToolBar.removeFromSuperview()
    }

    @objc private func tapEmptySpace(){
        self.view.endEditing(true)
    }
}

extension RegisterViewController: StartDateViewDelegate, EndDateViewDelegate {
    func startDateButtonDidTouched() {
        self.configureDatePicker()
        self.configureStartDateToolBar()
    }
    
    func endDateButtonDidTouched() {
        self.configureDatePicker()
        self.configureEndDateToolBar()
    }
    
    private func configureDatePicker() {
        self.view.addSubview(self.datePicker)
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.autoresizingMask = .flexibleWidth
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .inline
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.datePicker.timeZone = .autoupdatingCurrent
        self.datePicker.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            self.datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.datePicker.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureStartDateToolBar() {
        self.view.addSubview(self.dateToolBar)
        self.dateToolBar.translatesAutoresizingMaskIntoConstraints = false
        self.dateToolBar.barStyle = .default
        self.dateToolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onStartDoneTouched))]
        self.dateToolBar.sizeToFit()
        
        NSLayoutConstraint.activate([
            self.dateToolBar.bottomAnchor.constraint(equalTo: self.datePicker.topAnchor),
            self.dateToolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.dateToolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.dateToolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureEndDateToolBar() {
        self.view.addSubview(self.dateToolBar)
        self.dateToolBar.translatesAutoresizingMaskIntoConstraints = false
        self.dateToolBar.barStyle = .default
        self.dateToolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onEndDoneTouched))]
        self.dateToolBar.sizeToFit()
        
        NSLayoutConstraint.activate([
            self.dateToolBar.bottomAnchor.constraint(equalTo: self.datePicker.topAnchor),
            self.dateToolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.dateToolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.dateToolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
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

extension RegisterViewController: PlaceViewDelegate {
    func placeTextFieldDidReturn(_ place: String) {
        self.registerViewModel.didPlaceFinished(place)
    }
}

extension RegisterViewController: TypeViewDelegate {
    func typeDidSelected(_ idx: Int) {
        self.registerViewModel.didTypeTouched(idx)
    }
}

extension RegisterViewController: BuddyViewDelegate {
    func buddyDidDeleted(_ idx: Int) {
        self.registerViewModel.didBuddyDeleteTouched(in: idx)
    }
    
    func buddyDidSelected(_ buddy: Buddy) {
        self.registerViewModel.didBuddySelected(buddy)
    }
}

extension RegisterViewController: MemoViewDelegate {
    func memoTextFieldDidReturn(_ text: String) {
        self.registerViewModel.didMemoFinished(text)
    }
}

extension RegisterViewController: PictureViewDelegate {
    func pictureDidDeleted(_ idx: Int) {
        self.registerViewModel.didPictureDeleteTouched(in: idx)
    }
    
    func pictureButtonDidTouched() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
}
