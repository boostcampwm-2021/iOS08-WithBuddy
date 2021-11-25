//
//  ChartViewController.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/02.
//

import UIKit
import Combine

final class ChartViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bubbleChartView = BubbleChartView()
    private let purposeChartView = PurposeChartView()
    private let latestOldChartView = LatestOldChartView()
    private let viewModel = ChartViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.bubbleChartView.resetBubbles()
    }
    
    private func configure() {
        self.configureScrollView()
        self.configureContentView()
        self.configureBubbleChartView()
        self.configurePurposeChartView()
        self.configureLatestOldChartView()
        self.update(name: "정아")
    }
    
    private func bind() {
        self.viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] name in
                guard let name = name else { return }
                self?.bubbleChartView.update(name: name)
                self?.purposeChartView.update(name: name)
                self?.latestOldChartView.update(name: name)
            })
            .store(in: &self.cancellables)
                    
        self.viewModel.$buddyRank
            .sink { [weak self] list in
                self?.update(buddyList: list)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$purposeRank
            .sink { [weak self] list in
                self?.update(purposeList: list)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$latestBuddy
            .sink { [weak self] buddy in
                self?.update(latestBuddy: buddy)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$oldBuddy
            .sink { [weak self] buddy in
                self?.update(oldBuddy: buddy)
            }
            .store(in: &self.cancellables)
    }
    
    private func configureScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func configureBubbleChartView() {
        self.contentView.addSubview(self.bubbleChartView)
        self.bubbleChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bubbleChartView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.bubbleChartView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.bubbleChartView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func configurePurposeChartView() {
        self.contentView.addSubview(self.purposeChartView)
        self.purposeChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purposeChartView.leadingAnchor.constraint(equalTo: self.bubbleChartView.leadingAnchor),
            self.purposeChartView.topAnchor.constraint(equalTo: self.bubbleChartView.bottomAnchor, constant: 20),
            self.purposeChartView.trailingAnchor.constraint(equalTo: self.bubbleChartView.trailingAnchor)
        ])
    }
    
    private func configureLatestOldChartView() {
        self.contentView.addSubview(self.latestOldChartView)
        self.latestOldChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.latestOldChartView.leadingAnchor.constraint(equalTo: self.bubbleChartView.leadingAnchor),
            self.latestOldChartView.topAnchor.constraint(equalTo: self.purposeChartView.bottomAnchor, constant: 20),
            self.latestOldChartView.trailingAnchor.constraint(equalTo: self.bubbleChartView.trailingAnchor),
            self.latestOldChartView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func update(name: String) {
        self.bubbleChartView.update(name: name)
        self.purposeChartView.update(name: name)
        self.latestOldChartView.update(name: name)
    }
    
    private func update(buddyList: [(Buddy, Int)]?) {
        guard let list = buddyList else { return }
        self.bubbleChartView.update(list: list)
    }
    
    private func update(purposeList: [String]?) {
        guard let list = purposeList else { return }
        self.purposeChartView.update(list: list)
    }
    
    private func update(latestBuddy: Buddy?) {
        if let buddy = latestBuddy {
            self.latestOldChartView.update(latestName: buddy.name, face: buddy.face)
            return
        }
        self.latestOldChartView.showDefaultView()
    }
    
    private func update(oldBuddy: Buddy?) {
        guard let buddy = oldBuddy else { return }
        self.latestOldChartView.update(oldName: buddy.name, face: buddy.face)
    }

}
