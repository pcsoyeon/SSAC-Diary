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
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY.MM.dd"
    }
    
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
        configureNavigationBar()
        configureButton()
        configureTextField()
        configureTextView()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(touchUpCancelButton))
    }
    
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
        guard let title = writingView.titleTextField.text else { return }
        guard let diaryDate = writingView.subTitleTextField.text else { return }
        guard let context = writingView.contentTextView.text else { return }
        
        if title == "" || diaryDate == "" || context == "" {
            showAlertMessage(title: "내용을 모두 작성하지 않았어요!",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "나가기") { _ in
            } rightButtonAction: { _ in
                self.dismiss(animated: true)
            }
        } else {
            let task = UserDiary(diaryTitle: title,
                                 diaryContent: context,
                                 diaryDate: dateFormatter.date(from: diaryDate) ?? Date(),
                                 regDate: Date(),
                                 photo: nil)
            
            try! localRealm.write {
                localRealm.add(task)
                dismiss(animated: true)
            }
        }
    }
    
    @objc func touchUpCancelButton() {
        showAlertMessage(title: "작성 중에 나가면 저장이 되지 않아요",
                         leftButtonTitle: "취소",
                         rightButtonTitle: "나가기") { _ in
        } rightButtonAction: { _ in
            self.dismiss(animated: true)
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
