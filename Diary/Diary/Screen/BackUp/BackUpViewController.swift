//
//  BackUpViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/25.
//

import UIKit

import SnapKit
import Then

class BackUpViewController: BaseViewController {
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 5
        $0.addArrangedSubview(backupButton)
        $0.addArrangedSubview(restoreButton)
    }
    
    private var backupButton = UIButton().then {
        $0.setTitle("백업", for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
        $0.addTarget(self, action: #selector(touchUpBackUpButton), for: .touchUpInside)
    }
    
    private var restoreButton = UIButton().then {
        $0.setTitle("복구", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(touchUpRestoreButton), for: .touchUpInside)
    }
    
    private var listTableView = UITableView().then {
        $0.backgroundColor = .clear
    }

    override func configure() {
        setConstraints()
        configureButton()
        configureTableView()
    }
    
    private func setConstraints() {
        view.addSubviews([buttonStackView, listTableView])
        
        buttonStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureButton() {
        
    }
    
    private func configureTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.register(BackUpListTableViewCell.self, forCellReuseIdentifier: BackUpListTableViewCell.reuseIdentifier)
    }
    
    @objc func touchUpBackUpButton() {
        
    }
    
    @objc func touchUpRestoreButton() {
        
    }
}

// MARK: - UITableView Protocol

extension BackUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackUpListTableViewCell.reuseIdentifier, for: indexPath) as? BackUpListTableViewCell else { return UITableViewCell() }
        return cell
    }
}
