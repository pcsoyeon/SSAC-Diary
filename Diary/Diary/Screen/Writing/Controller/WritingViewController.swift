//
//  WritingViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import Kingfisher
import RealmSwift // 1.
import SnapKit
import Then

final class WritingViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private var writingView = WritignView()
    
    // MARK: - Property
    
    private let localRealm = try! Realm() // 2.
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = writingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at: ", localRealm.configuration.fileURL!)
    }
    
    // MARK: - UI Method
    
    override func configure() {
        title = "글쓰기"
        
        configureButton()
        configureTextField()
        configureTextView()
    }
    
    // MARK: - Custom Method
    
    private func configureButton() {
        writingView.searchButton.addTarget(self, action: #selector(touchUpSearchButton), for: .touchUpInside)
        writingView.saveButton.addTarget(self, action: #selector(touchUpSaveButton), for: .touchUpInside)
    }
    
    private func configureTextField() {
        writingView.titleTextField.delegate = self
        writingView.subTitleTextField.delegate = self
    }
    
    private func configureTextView() {
        writingView.contentTextView.delegate = self
    }
    
    // MARK: - @objc
    
    @objc func touchUpSearchButton() {
        let viewController = ImageSearchViewController()
        viewController.doneButtonActionHandler = { imagURL in
            guard let url = imagURL else { return }
            self.writingView.imageView.kf.setImage(with: URL(string: url))
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func touchUpSaveButton() {
        let task = UserDiary(diaryTitle: "오늘의 일기", diaryContent: "오늘도 최이준은 하라고 했다.", diaryDate: Date(), regDate: Date(), photo: nil) // record
        
        try! localRealm.write {
            localRealm.add(task) // create
            print("Succeed")
            dismiss(animated: true)
        }
    }
}

// MARK: - UITextField Protocol

extension WritingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemMint.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        return true
    }
}

// MARK: - UITextView Delegate

extension WritingViewController: UITextViewDelegate {
    
}
