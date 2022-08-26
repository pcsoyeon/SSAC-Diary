//
//  ViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import FSCalendar
import RealmSwift
import SnapKit
import Then

class MainViewController: UIViewController {

    // MARK: - UI Property
    
    private var tableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Property
    
    let repository = UserDiaryRepository()
    
    var tasks: Results<UserDiary>! {
        didSet {
            tableView.reloadData()
            calendar.reloadData()
        }
    }
    
    private lazy var calendar = FSCalendar().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
    }
    
    private var dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyMMdd"
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at: ", repository.localRealm.configuration.fileURL!)
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealmData()
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews([tableView, calendar])
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            make.topMargin.equalTo(300)
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(touchUpPlusButton))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(touchUpSortButton))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(touchUpFilterButton))
        let backUpButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(touchUpBackUpButton))
        
        self.navigationItem.leftBarButtonItems = [sortButton, filterButton, backUpButton]
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Custom Method
    
    private func fetchRealmData() {
        tasks = repository.fetch()
    }
    
    // MARK: - @objc
    
    @objc func touchUpPlusButton() {
        transition(WritingViewController(), transitionStyle: .presentFullNavigation)
    }
    
    @objc func touchUpSortButton() {
        tasks = repository.fetchSort("regDate")
    }
    
    @objc func touchUpFilterButton() {
        // realm filter query, NSPredicate
        tasks = repository.fetchFilter("행복")
    }
    
    @objc func touchUpBackUpButton() {
        transition(BackUpViewController(), transitionStyle: .push)
    }
}

// MARK: - UITableView Protocol

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            
            self.repository.updateFavorite(item: self.tasks[indexPath.row])
            
            // reload 방법
            // 1. 스와이프 한 셀 하나만 reload rows 코드 구현 > 상대적으로 효율성
            // 2. 데이터가 변경되었으니 다시 realm에서 데이터 갖고 오기 > didSet에서 일괄적 형태로 갱신
            self.fetchRealmData()
        }
        
        favorite.backgroundColor = .systemMint
        
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        
        let pin = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("pin button clicked")
        }
        pin.backgroundColor = .systemPink
        pin.image = UIImage(systemName: "pin")
        
        return UISwipeActionsConfiguration(actions: [favorite, pin])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
            
            self.repository.deleteItem(item: self.tasks[indexPath.row])
            
            self.fetchRealmData()
        }
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier) as? MainTableViewCell else { return UITableViewCell() }
        cell.setData(tasks[indexPath.row])
        cell.contentImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        return cell
    }
}

// MARK: - FSCalendar Protocol

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.fetchDate(date: date).count
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return nil
//    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return dateFormatter.string(from: date) == "220907" ? "오프라인" : nil
    }
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star.fill")
//    }
    
    // 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(date: date)
    }
}
