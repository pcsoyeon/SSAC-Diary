//
//  BackUpViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/25.
//

import UIKit

import SnapKit
import Then
import Zip

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
        // 0. 백업할 파일의 URL 배열
        var urlPaths = [URL]()
        
        // 1. 도큐먼트 위치에 백업 파일 확인 (파일 매니저를 통해서)
        // 1.0 도큐먼트에 접근
        guard let path = documentDirectoryPath() else {
            showDefaultAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        // 1.1 경로
        let realmFile = path.appendingPathComponent("default.realm")
        // 1.2 경로에 파일이 있는지 확인
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showDefaultAlertMessage(title: "백업할 파일이 없습니다.") // 렘 파일이 없을 수도 있으므로 오류 메시지 출력
            return
        }
        // 1.3 파일이 있다면 urlPath에 추가 (path가 string 타입이므로 url로 변환)
        if let url = URL(string: realmFile.path) {
            urlPaths.append(url)
        }
        
        // 2. 백업할 파일이 있다면 파일 압축: URL을 기반으로 압축 만들기
        // 2.0 import Zip
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SoKyteDiary_1")
            print("Archive Location: \(zipFilePath)")
            
            // 3. 압축이 완료가 되면 ActivityViewController 띄우기
            // 파일을 압축했다면 > Activity Controller 띄우기
            showActivityViewController()
        } catch {
            showDefaultAlertMessage(title: "압축을 실패했습니다")
            // ex. 만약 default.realm이 아닌 다른 a.realm을 압축하려고 한다면 오류 발생
        }
        
        // TODO: -  저장 공간 확인 및 .. 등의 작업 
    }
    
    private func showActivityViewController() {
        
        guard let path = documentDirectoryPath() else {
            showDefaultAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("SoKyteDiary_1.zip") // 주의) 확장자까지 작성
        
        let viewController = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(viewController, animated: true)
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
