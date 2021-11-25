//
//  GatheringDetailViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/10.
//

import UIKit
import Combine

class GatheringDetailViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var dateTitleLabel = PurpleTitleLabel()
    private lazy var dateBackgroundView = WhiteView()
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
    private lazy var pictureCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var pictureDataSource = UICollectionViewDiffableDataSource<Int, URL>(collectionView: self.pictureCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: URL) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifier, for: indexPath) as? PictureCollectionViewCell else { preconditionFailure() }
        cell.configure(url: itemIdentifier)
        return cell
    }
    
    private var gatheringDetailViewModel = GatheringDetailViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .done, target: self, action: #selector(self.editGathering))
    }

    private func configure() {
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        
        self.configureScrollView()
        self.configureContentView()
        self.configureDatePart()
        self.configurePlacePart()
        self.configurePurposePart()
        self.configureBuddyPart()
        self.configureMemoPart()
        self.configurePicturePart()
    }
    
    private func bind() {
        self.signalBind()
        self.dataBind()
    }
    
    private func signalBind() {
        self.gatheringDetailViewModel.goEditSignal
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] gathering in
                let gatheringEditViewController = GatheringEditViewController()
                gatheringEditViewController.configure(by: gathering)
                gatheringEditViewController.delegate = self
                self?.navigationController?.pushViewController(gatheringEditViewController, animated: true)
            })
            .store(in: &cancellables)
    }
    
    private func dataBind() {
        self.gatheringDetailViewModel.$gathering
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] gathering in
                guard let gathering = gathering else { return }
                self?.datePicker.date = gathering.date
                self?.placeTextField.text = gathering.place

                var purposeSnapshot = NSDiffableDataSourceSnapshot<Int, CheckableInfo>()
                purposeSnapshot.appendSections([0])
                let purposeList = PurposeCategory.allCases.map({ placeType -> CheckableInfo? in
                    var korDescription = "\(placeType)"
                    if let kor = self?.gatheringDetailViewModel.engToKor(eng: "\(placeType)") {
                        korDescription = kor
                    }
                    if gathering.purpose.contains(placeType.description) { return CheckableInfo(engDescription: "\(placeType)", korDescription: korDescription, check: true) }
                    return nil
                }).compactMap({ $0 })
                purposeSnapshot.appendItems(purposeList)
                self?.purposeDataSource.apply(purposeSnapshot, animatingDifferences: true)
                
                var buddySnapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                if gathering.buddyList.isEmpty {
                    buddySnapshot.appendSections([0])
                    buddySnapshot.appendItems([Buddy(id: UUID(), name: "친구없음", face: "DefaultFace")])
                } else {
                    buddySnapshot.appendSections([0])
                    buddySnapshot.appendItems(gathering.buddyList)
                }
                self?.buddyDataSource.apply(buddySnapshot, animatingDifferences: true)
                self?.memoTextView.text = gathering.memo
            
                guard let pictures = gathering.picture else { return }
                var pictureSnapshot = NSDiffableDataSourceSnapshot<Int, URL>()
                if pictures.isEmpty {
                    guard let filePath = Bundle.main.path(forResource: "defaultImage", ofType: "png") else {
                        return
                    }
                    let fileUrl = URL(fileURLWithPath: filePath)
                    pictureSnapshot.appendSections([0])
                    pictureSnapshot.appendItems([fileUrl])
                } else {
                    pictureSnapshot.appendSections([0])
                    pictureSnapshot.appendItems(pictures)
                }
                self?.pictureDataSource.apply(pictureSnapshot, animatingDifferences: true)
            })
            .store(in: &self.cancellables)
    }
    
    func configure(by gathering: Gathering) {
        self.gatheringDetailViewModel.didGatheringChanged(to: gathering)
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
        self.configureDateBackground()
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
    
    private func configureDateBackground() {
        self.contentView.addSubview(self.dateBackgroundView)
        self.dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateBackgroundView.topAnchor.constraint(equalTo: self.dateTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.dateBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.dateBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.dateBackgroundView.heightAnchor.constraint(equalToConstant: .backgroudHeight)
        ])
    }
    
    private func configureDatePicker() {
        self.dateBackgroundView.addSubview(self.datePicker)
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.datePicker.timeZone = .autoupdatingCurrent
        self.datePicker.isUserInteractionEnabled = false
        
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.datePicker.leadingAnchor.constraint(equalTo: self.dateBackgroundView.leadingAnchor, constant: .plusInset),
            self.datePicker.centerYAnchor.constraint(equalTo: self.dateBackgroundView.centerYAnchor)
        ])
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
            self.placeTitleLabel.topAnchor.constraint(equalTo: self.dateBackgroundView.bottomAnchor, constant: .plusInset),
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
        self.placeTextField.isUserInteractionEnabled = false
        
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
        self.purposeTitleLabel.text = "모임 목적"
        
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
        self.purposeCollectionView.isUserInteractionEnabled = false
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
            self.purposeCollectionView.heightAnchor.constraint(equalToConstant: .buddyAndPurposeHeight)
        ])
    }
    
    // MARK: - BuddyPart
    
    private func configureBuddyPart() {
        self.configureBuddyTitle()
        self.configureBuddyCollectionView()
    }
    
    private func configureBuddyTitle() {
        self.contentView.addSubview(self.buddyTitleLabel)
        self.buddyTitleLabel.text = "만난 버디"
        
        self.buddyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyTitleLabel.topAnchor.constraint(equalTo: self.purposeCollectionView.bottomAnchor, constant: .plusInset),
            self.buddyTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.buddyTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configureBuddyCollectionView() {
        self.contentView.addSubview(self.buddyCollectionView)
        self.buddyCollectionView.backgroundColor = .clear
        self.buddyCollectionView.showsHorizontalScrollIndicator = false
        
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: .buddyAndPurposeWidth, height: .buddyAndPurposeHeight)
        
        self.buddyCollectionView.collectionViewLayout = layout
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.buddyTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.buddyCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.buddyCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.buddyCollectionView.heightAnchor.constraint(equalToConstant: .buddyAndPurposeHeight)
        ])
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
        self.memoTextView.isUserInteractionEnabled = false
        
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
    
    private func configurePictureCollectionView() {
        self.contentView.addSubview(self.pictureCollectionView)
        self.pictureCollectionView.backgroundColor = .clear
        self.pictureCollectionView.showsHorizontalScrollIndicator = false
        self.pictureCollectionView.isUserInteractionEnabled = true
        
        self.pictureCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureCollectionView.topAnchor.constraint(equalTo: self.pictureTitleLabel.bottomAnchor, constant: .innerPartInset),
            self.pictureCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .plusInset),
            self.pictureCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .minusInset),
            self.pictureCollectionView.heightAnchor.constraint(equalTo: self.pictureCollectionView.widthAnchor),
            self.pictureCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
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
    
    @objc private func editGathering() {
        self.gatheringDetailViewModel.didEditButtonTouched()
    }
    
}

extension GatheringDetailViewController: GatheringEditDelegate {
    
    func didGatheringEdited(to gathering: Gathering) {
        self.gatheringDetailViewModel.didGatheringChanged(to: gathering)
    }
    
}
