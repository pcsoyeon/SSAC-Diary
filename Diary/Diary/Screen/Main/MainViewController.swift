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
        $0.backgroundColor = .gray
    }
    
    // MARK: - Property
    
    let localRealm = try! Realm()
    
    var tasks: Results<UserDiary>!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        getRealmData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false)
        tableView.reloadData()
    }
    
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
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func getRealmData() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    @objc func touchUpPlusButton() {
        let viewController = WritingViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "\(tasks[indexPath.row].diaryTitle)"
        return cell
    }
}
