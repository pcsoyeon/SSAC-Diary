//
//  ViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import RealmSwift
import SnapKit
import Then

class MainViewController: UIViewController {

    // MARK: - UI Property
    
    private var tableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Property
    
    let localRealm = try! Realm()
    
    var tasks: Results<UserDiary>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at: ", localRealm.configuration.fileURL!)
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
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        configureNavigationBarUI()
    }
    
    private func configureNavigationBarUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(touchUpPlusButton))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(touchUpSortButton))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(touchUpFilterButton))
        self.navigationItem.leftBarButtonItems = [sortButton, filterButton]
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Custom Method
    
    private func fetchRealmData() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    // MARK: - @objc
    
    @objc func touchUpPlusButton() {
        let viewController = UINavigationController(rootViewController: WritingViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    @objc func touchUpSortButton() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "regDate", ascending: true)
    }
    
    @objc func touchUpFilterButton() {
        // realm filter query, NSPredicate
        tasks = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS '똥'")
    }
}

// MARK: - UITableView Protocol

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
//            do {
//                try self.localRealm.write {
//                    print("어쩌고")
//                }
//            } catch {
//                print("오류")
//            }
            
            try! self.localRealm.write {
                // 하나의 레코드에서 특정 컬럼 하나만 변경
                self.tasks[indexPath.row].favorite.toggle()
                
                // 하나의 테이블에 특정 컬럼 전체 값을 변경
//                self.tasks.setValue(true, forKey: "favorite")
                
                // 하나의 레코드에서 여러 컬럼을 변경
//                self.localRealm.create(UserDiary.self,
//                                       value: ["objectId" : self.tasks[indexPath.row].objectId,
//                                               "diaryContent" : "내용뿡뿡",
//                                               "diaryTitle" : "제목뿡뿡"],
//                                       update: .modified)
            }
            
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
            try! self.localRealm.write {
                self.localRealm.delete(self.tasks[indexPath.row])
            }
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
        return cell
    }
}
