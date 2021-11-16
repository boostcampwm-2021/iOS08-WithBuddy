//
//  CalendarDetailViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/07.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    
    private lazy var detailLabel = UILabel()
    private lazy var detailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var calendarDetailViewModel: CalendarDetailViewModel
    
    init(calendarDetailViewModel: CalendarDetailViewModel) {
        self.calendarDetailViewModel = calendarDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.calendarDetailViewModel = CalendarDetailViewModel(selectedDate: Date())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.configure()
    }
    
    private func configure() {
        
    }

}
