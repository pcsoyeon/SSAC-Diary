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
            print("Tasks Changed")
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
        getRealmData()
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
    
    private func getRealmData() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    // MARK: - @objc
    
    @objc func touchUpPlusButton() {
        let viewController = WritingViewController()
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
