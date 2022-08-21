//
//  WritingViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import SnapKit
import Then

final class WritingViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private var writingView = WritignView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = writingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationController?.pushViewController(viewController, animated: true)
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
