//
//  GatheringEditViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/16.
//

import UIKit
import Combine

final class GatheringEditViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var dateTitleLabel = PurpleTitleLabel()
    private lazy var datePicker = UIDatePicker()
    private lazy var placeTitleLabel = PurpleTitleLabel()
    private lazy var placeBackgroundView = WhiteView()
    private lazy var placeTextField = UITextField()
    
    private lazy var purposeTitleLabel = PurpleTitleLabel()
    private lazy var purposeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var purposeDataSource = UICollectionViewDiffableDataSource<Int, CheckableInfo>(collectionView: self.purposeCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CheckableInfo) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifier, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: "\(itemIdentifier.engDescription)"), text: "\(itemIdentifier.korDescription)", check: itemIdentifier.check)
        return cell
    }
    
    private lazy var buddyTitleLabel = PurpleTitleLabel()
    private lazy var buddyAddButton = UIButton()
    private lazy var buddyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var buddyDataSource = UICollectionViewDiffableDataSource<Int, Buddy>(collectionView: self.buddyCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Buddy) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifier, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.face), text: itemIdentifier.name)
        return cell
    }
    
    private lazy var memoTitleLabel = PurpleTitleLabel()
    private lazy var memoBackgroundView = WhiteView()
    private lazy var memoTextView = UITextView()
    
    private lazy var pictureTitleLabel = PurpleTitleLabel()
    private lazy var pictureAddButton = UIButton()
    private lazy var pictureCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var pictureDataSource = UICollectionViewDiffableDataSource<Int, URL>(collectionView: self.pictureCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: URL) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifier, for: indexPath) as? PictureCollectionViewCell else { preconditionFailure() }
        cell.configure(url: itemIdentifier)
        return cell
    }
    
    private lazy var deleteButton = UIButton()
    
    private var gatheringEditViewModel = GatheringEditViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configure()
        self.gatheringEditViewModel.didDatePicked(Date())
        self.title = "모임 편집"
        self.navigationItem.backButtonTitle = "Back"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelPurple as Any]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(self.alertCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.addGathering))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard !placeTextField.isFirstResponder else { return }
        let memoButtomY = self.memoBackgroundView.frame.origin.y + self.memoBackgroundView.frame.height - self.scrollView.bounds.origin.y
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let offset = memoButtomY + keyboardSize.height - self.scrollView.bounds.height
            if offset > 0 {
                self.scrollView.bounds.origin.y += offset
            }
        }
    }
    
    private func bind() {
        self.bindPlace()
        self.bindPurposeList()
        self.bindBuddyList()
        self.bindMemo()
        self.bindPictures()
        self.bindSignal()
    }
    
    func configure(by gathering: Gathering) {
        self.gatheringEditViewModel.gatheringId = gathering.id
        self.datePicker.date = gathering.date
        self.gatheringEditViewModel.didDatePicked(gathering.date)
        self.gatheringEditViewModel.didPlaceChanged(gathering.place ?? "")
        for (idx, place) in PurposeCategory.allCases.enumerated() {
            if gathering.purpose.contains(place.description) {
                self.gatheringEditViewModel.didPurposeTouched(idx)
            }
        }
        self.gatheringEditViewModel.didBuddyUpdated(gathering.buddyList)
        self.gatheringEditViewModel.didMemoChanged(gathering.memo ?? "")
        guard let pictures = gathering.picture else { return }
        for url in pictures {
            self.gatheringEditViewModel.didPicturePicked(url)
        }
    }
    
    private func bindPlace() {
        self.gatheringEditViewModel.$place
            .receive(on: DispatchQueue.main)
            .sink { [weak self] place in
                self?.placeTextField.text = place
            }
            .store(in: &self.cancellables)
    }
    
    private func bindPurposeList() {
        self.gatheringEditViewModel.$purposeList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] purposeList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, CheckableInfo>()
                snapshot.appendSections([0])
                snapshot.appendItems(purposeList)
                self?.purposeDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
    }
    
    private func bindBuddyList() {
        self.gatheringEditViewModel.$buddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                if buddyList.isEmpty {
                    snapshot.appendSections([0])
                    snapshot.appendItems([Buddy(id: UUID(), name: "친구없음", face: "DefaultFace")])
                } else {
                    snapshot.appendSections([0])
                    snapshot.appendItems(buddyList)
                }
                self?.buddyDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
    }
    
    private func bindMemo() {
        self.gatheringEditViewModel.$memo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] memo in
                self?.memoTextView.text = memo
            }
            .store(in: &self.cancellables)
    }
    
    private func bindPictures() {
        self.gatheringEditViewModel.$pictures
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pictures in
                var snapshot = NSDiffableDataSourceSnapshot<Int, URL>()
                if pictures.isEmpty {
                    guard let filePath = Bundle.main.path(forResource: "defaultImage", ofType: "png") else { return }
                    let fileUrl = URL(fileURLWithPath: filePath)
                    snapshot.appendSections([0])
                    snapshot.appendItems([fileUrl])
                } else {
                    snapshot.appendSections([0])
                    snapshot.appendItems(pictures)
                }
                self?.pictureDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
    }
    
    private func bindSignal() {
        self.gatheringEditViewModel.editDoneSignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] gathering in
                self?.alertSuccess(gathering: gathering)
                self?.registerNotification(gathering: gathering)
            }
            .store(in: &self.cancellables)
        
        self.gatheringEditViewModel.editFailSignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                self?.alertError(result)
            }
            .store(in: &self.cancellables)
        
        self.gatheringEditViewModel.addBuddySignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] buddyList in
                let buddyChoiceViewController = BuddyChoiceViewController()
                buddyChoiceViewController.delegate = self
                buddyChoiceViewController.configureBuddyList(by: buddyList)
                self?.navigationController?.pushViewController(buddyChoiceViewController, animated: true)
            }
            .store(in: &self.cancellables)
    }
    
    private func registerNotification(gathering: Gathering) {
        guard let nextDay = Calendar.current.date(byAdding: .minute, value: 1, to: gathering.date) else { return }
        let content = UNMutableNotificationContent()
        content.title = "위드버디"
        let firstBuddyName = gathering.buddyList.first?.name ?? ""
        let buddyCountString = gathering.buddyList.count == 1 ? "" : "외 \(gathering.buddyList.count-1)명"
        content.body = "어제 \(firstBuddyName)님 \(buddyCountString)과의 만남은 어떠셨나요?"
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextDay)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        self.deleteNotification(id: gathering.id)
        
        let request = UNNotificationRequest(identifier: gathering.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func deleteNotification(id: UUID) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id.uuidString])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    private func configure() {
        self.view.backgroundColor = .backgroundPurple
        
        self.configureScrollView()
        self.configureContentView()
        self.configureDatePart()
        self.configurePlacePart()
        self.configurePurposePart()
        self.configureBuddyPart()
        self.configureMemoPart()
        self.configurePicturePart()
        self.configureDeleteButton()
    }
    
    private func configureScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapEmptySpace)))
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    // MARK: - DatePart
    
    private func configureDatePart() {
        self.configureDateTitle()
        self.configureDatePicker()
    }
    
    private func configureDateTitle() {
        self.contentView.addSubview(self.dateTitleLabel)
        self.dateTitleLabel.text = "모임 날짜"
        
        self.dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: .innerPartInset),
            self.dateTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.dateTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configureDatePicker() {
        self.contentView.addSubview(self.datePicker)
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.datePicker.timeZone = .autoupdatingCurrent
        self.datePicker.addTarget(self, action: #selector(self.didDateChanged), for: .valueChanged)
        
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.datePicker.topAnchor.constraint(equalTo: self.dateTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.datePicker.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.datePicker.heightAnchor.constraint(equalToConstant: .backgroudHeight)
        ])
    }
    
    @objc private func didDateChanged(_ sender: UIDatePicker) {
        self.gatheringEditViewModel.didDatePicked(sender.date)
    }
    
    // MARK: - PlacePart
    
    private func configurePlacePart() {
        self.configurePlaceTitle()
        self.configurePlaceBackground()
        self.configurePlaceTextField()
    }
    
    private func configurePlaceTitle() {
        self.contentView.addSubview(self.placeTitleLabel)
        self.placeTitleLabel.text = "모임 장소"
        
        self.placeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeTitleLabel.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: .plusInset),
            self.placeTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.placeTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configurePlaceBackground() {
        self.contentView.addSubview(self.placeBackgroundView)
        self.placeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeBackgroundView.topAnchor.constraint(equalTo: self.placeTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.placeBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.placeBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.placeBackgroundView.heightAnchor.constraint(equalToConstant: .backgroudHeight)
        ])
    }
    
    private func configurePlaceTextField() {
        self.placeBackgroundView.addSubview(self.placeTextField)
        self.placeTextField.delegate = self
        
        self.placeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeTextField.topAnchor.constraint(equalTo: self.placeBackgroundView.topAnchor),
            self.placeTextField.leadingAnchor.constraint(equalTo: self.placeBackgroundView.leadingAnchor, constant: .plusInset),
            self.placeTextField.trailingAnchor.constraint(equalTo: self.placeBackgroundView.trailingAnchor, constant: .minusInset),
            self.placeTextField.bottomAnchor.constraint(equalTo: self.placeBackgroundView.bottomAnchor)
        ])
    }
    
    // MARK: - PurposePart
    
    private func configurePurposePart() {
        self.configurePurposeTitle()
        self.configurePurposeCollectionView()
    }
    
    private func configurePurposeTitle() {
        self.contentView.addSubview(self.purposeTitleLabel)
        self.purposeTitleLabel.text = "목적 선택"
        
        self.purposeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purposeTitleLabel.topAnchor.constraint(equalTo: self.placeBackgroundView.bottomAnchor, constant: .plusInset),
            self.purposeTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.purposeTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configurePurposeCollectionView() {
        self.contentView.addSubview(self.purposeCollectionView)
        self.purposeCollectionView.backgroundColor = .clear
        self.purposeCollectionView.showsHorizontalScrollIndicator = false
        self.purposeCollectionView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.collectionViewDidTouched(_:)))
        self.purposeCollectionView.addGestureRecognizer(tap)
        self.purposeCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)

        let purposeFlowLayout = UICollectionViewFlowLayout()
        let purposeWidth = (self.view.frame.width - (.plusInset * 2))/5 - .innerPartInset
        purposeFlowLayout.itemSize = CGSize(width: purposeWidth, height: .buddyAndPurposeHeight)
        self.purposeCollectionView.collectionViewLayout = purposeFlowLayout

        self.purposeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purposeCollectionView.topAnchor.constraint(equalTo: self.purposeTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.purposeCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.purposeCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.purposeCollectionView.heightAnchor.constraint(equalToConstant: .purposeWholeHeight)
        ])
    }

    @objc func collectionViewDidTouched(_ sender: UITapGestureRecognizer) {
       if let indexPath = self.purposeCollectionView.indexPathForItem(at: sender.location(in: self.purposeCollectionView)) {
           self.gatheringEditViewModel.didPurposeTouched(indexPath.item)
           
           guard let cell = self.purposeCollectionView.cellForItem(at: indexPath) as? ImageTextCollectionViewCell  else { return }
           cell.animateButtonTap(scale: 0.8)
       }
    }
    
    // MARK: - BuddyPart
    
    private func configureBuddyPart() {
        self.configureBuddyTitle()
        self.configureBuddyAddButton()
        self.configureBuddyCollectionView()
    }
    
    private func configureBuddyTitle() {
        self.contentView.addSubview(self.buddyTitleLabel)
        self.buddyTitleLabel.text = "버디 추가"
        
        self.buddyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyTitleLabel.topAnchor.constraint(equalTo: self.purposeCollectionView.bottomAnchor, constant: .plusInset),
            self.buddyTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.buddyTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configureBuddyAddButton() {
        self.contentView.addSubview(self.buddyAddButton)
        let config = UIImage.SymbolConfiguration(
            pointSize: .buddyAndPurposeWidth, weight: .medium, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        self.buddyAddButton.setImage(image, for: .normal)
        self.buddyAddButton.addTarget(self, action: #selector(self.onBuddyAddButtonTouched(_:)), for: .touchUpInside)
        
        self.buddyAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyAddButton.topAnchor.constraint(equalTo: self.buddyTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.buddyAddButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.buddyAddButton.widthAnchor.constraint(equalToConstant: .buddyAndPurposeWidth),
            self.buddyAddButton.heightAnchor.constraint(equalTo: self.buddyAddButton.widthAnchor)
        ])
    }
    
    private func configureBuddyCollectionView() {
        self.contentView.addSubview(self.buddyCollectionView)
        self.buddyCollectionView.backgroundColor = .clear
        self.buddyCollectionView.showsHorizontalScrollIndicator = false
        self.buddyCollectionView.delegate = self
        
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: .buddyAndPurposeWidth, height: .buddyAndPurposeHeight)
        
        self.buddyCollectionView.collectionViewLayout = layout
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.buddyAddButton.topAnchor),
            self.buddyCollectionView.leadingAnchor.constraint(equalTo: self.buddyAddButton.trailingAnchor, constant: .innerPartInset),
            self.buddyCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .plusInset),
            self.buddyCollectionView.heightAnchor.constraint(equalToConstant: .buddyAndPurposeHeight)
        ])
    }
    
    @objc private func onBuddyAddButtonTouched(_ sender: UIButton) {
        self.buddyAddButton.animateButtonTap(scale: 0.8)
        self.gatheringEditViewModel.didAddBuddyTouched()
    }
    
    // MARK: - MemoPart
    
    private func configureMemoPart() {
        self.configureMemoTitle()
        self.configureMemoBackground()
        self.configureMemoTextView()
    }
    
    private func configureMemoTitle() {
        self.contentView.addSubview(self.memoTitleLabel)
        self.memoTitleLabel.text = "메모"
        
        self.memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTitleLabel.topAnchor.constraint(equalTo: self.buddyCollectionView.bottomAnchor, constant: .plusInset),
            self.memoTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.memoTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configureMemoBackground() {
        self.contentView.addSubview(self.memoBackgroundView)
        self.memoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoBackgroundView.topAnchor.constraint(equalTo: self.memoTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.memoBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.memoBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.memoBackgroundView.heightAnchor.constraint(equalToConstant: .memoHeight)
        ])
    }
    
    private func configureMemoTextView() {
        self.memoBackgroundView.addSubview(self.memoTextView)
        self.memoTextView.backgroundColor = .systemBackground
        self.memoTextView.font =  UIFont.systemFont(ofSize: .labelSize, weight: .medium)
        self.memoTextView.textContentType = .none
        self.memoTextView.autocapitalizationType = .none
        self.memoTextView.autocorrectionType = .no
        self.memoTextView.delegate = self
        
        self.memoTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTextView.topAnchor.constraint(equalTo: self.memoBackgroundView.topAnchor, constant: .plusInset),
            self.memoTextView.leadingAnchor.constraint(equalTo: self.memoBackgroundView.leadingAnchor, constant: .plusInset),
            self.memoTextView.trailingAnchor.constraint(equalTo: self.memoBackgroundView.trailingAnchor, constant: .minusInset),
            self.memoTextView.bottomAnchor.constraint(equalTo: self.memoBackgroundView.bottomAnchor, constant: .minusInset)
        ])
    }
    
    // MARK: - PicturePart
    
    private func configurePicturePart() {
        self.configurePictureTitle()
        self.configurePictureAddButton()
        self.configurePictureCollectionView()
    }
    
    private func configurePictureTitle() {
        self.contentView.addSubview(self.pictureTitleLabel)
        self.pictureTitleLabel.text = "사진"
        
        self.pictureTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureTitleLabel.topAnchor.constraint(equalTo: self.memoBackgroundView.bottomAnchor, constant: .plusInset),
            self.pictureTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.pictureTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configurePictureAddButton() {
        self.contentView.addSubview(self.pictureAddButton)
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .medium, scale: .default)
        let image = UIImage(systemName: "plus.square", withConfiguration: config)
        self.pictureAddButton.setImage(image, for: .normal)
        self.pictureAddButton.addTarget(self, action: #selector(self.onPictureButtonTouched(_:)), for: .touchUpInside)
        
        self.pictureAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureAddButton.centerYAnchor.constraint(equalTo: self.pictureTitleLabel.centerYAnchor),
            self.pictureAddButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.pictureAddButton.widthAnchor.constraint(equalToConstant: .pictureAddButonSize),
            self.pictureAddButton.heightAnchor.constraint(equalTo: self.pictureAddButton.widthAnchor)
        ])
    }
    
    private func configurePictureCollectionView() {
        self.contentView.addSubview(self.pictureCollectionView)
        self.pictureCollectionView.backgroundColor = .clear
        self.pictureCollectionView.showsHorizontalScrollIndicator = false
        self.pictureCollectionView.isUserInteractionEnabled = true
        self.pictureCollectionView.delegate = self
        
        self.pictureCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureCollectionView.topAnchor.constraint(equalTo: self.pictureTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.pictureCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.pictureCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.pictureCollectionView.heightAnchor.constraint(equalTo: self.pictureCollectionView.widthAnchor)
        ])
        
        self.pictureCollectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.identifier)
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.9)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        self.pictureCollectionView.collectionViewLayout = layout
    }
    
    @objc private func onPictureButtonTouched(_ sender: UIButton) {
        self.pictureAddButton.animateButtonTap(scale: 0.8)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - DeleteButtonPart
    
    private func configureDeleteButton() {
        self.contentView.addSubview(self.deleteButton)
        self.deleteButton.backgroundColor = .graphRed
        self.deleteButton.layer.cornerRadius = .buttonCornerRadius
        self.deleteButton.setTitle("모임 삭제", for: .normal)
        self.deleteButton.addTarget(self, action: #selector(self.deleteGathering), for: .touchUpInside)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.deleteButton.topAnchor.constraint(equalTo: self.pictureCollectionView.bottomAnchor, constant: .plusInset),
            self.deleteButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.deleteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.deleteButton.heightAnchor.constraint(equalToConstant: .backgroudHeight),
            self.deleteButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    // MARK: - CompletePart
    
    @objc private func alertCancel() {
        let alert = UIAlertController(title: "기록한 내용은 저장되지 않습니다. 그래도 나가시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(noAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func alertSuccess(gathering: Gathering) {
        let alert = UIAlertController(title: "편집 완료", message: "모임 편집이 완료되었습니다!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func alertError(_ error: RegisterError) {
        let alert = UIAlertController(title: "편집 실패", message: error.errorDescription, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func addGathering() {
        self.gatheringEditViewModel.didDoneTouched()
    }
    
    @objc private func deleteGathering() {
        guard let id = self.gatheringEditViewModel.gatheringId else { return }
        self.deleteButton.animateButtonTap(scale: 0.9)
        let alert = UIAlertController(title: "모임 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            self.gatheringEditViewModel.didDeleteButtonTouched()
            self.deleteNotification(id: id)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
    }
    
    @objc private func tapEmptySpace(){
        self.view.endEditing(true)
    }
    
}

extension GatheringEditViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if collectionView == self.pictureCollectionView {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash")) { _ in
                    self.gatheringEditViewModel.didBuddyDeleteTouched(in: indexPath.item)
                }
                return UIMenu(title: "이 사진을", children: [delete])
            })
        } else {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                let delete = UIAction(title: NSLocalizedString("삭제", comment: ""),
                                      image: UIImage(systemName: "trash")) { _ in
                    self.gatheringEditViewModel.didBuddyDeleteTouched(in: indexPath.item)
                }
                return UIMenu(title: "이 버디를", children: [delete])
            })
        }
    }
    
}

extension GatheringEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.gatheringEditViewModel.didPlaceChanged(text)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.gatheringEditViewModel.didPlaceChanged(text)
    }
    
}

extension GatheringEditViewController: UITextViewDelegate {
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.gatheringEditViewModel.didMemoChanged(text)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .labelPurple {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "모임에 대한 메모를 적어주세요."
            textView.textColor = .labelPurple
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        self.gatheringEditViewModel.didMemoChanged(text)
    }
    
}

extension GatheringEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let url = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return
        }
        self.gatheringEditViewModel.didPicturePicked(url)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GatheringEditViewController: BuddyChoiceDelegate {
    
    func buddySelectingDidCompleted(_ buddyList: [Buddy]) {
        self.gatheringEditViewModel.didBuddyUpdated(buddyList)
    }
    
}
