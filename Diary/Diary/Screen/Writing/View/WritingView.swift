//
//  WritingView.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import SnapKit
import Then

final class WritignView: BaseView {
    
    // MARK: - UI Property
    
    private var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private var contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .systemGray5
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.addArrangedSubview(galleryButton)
        $0.addArrangedSubview(searchButton)
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 5
    }
    
    var galleryButton = UIButton().then {
        $0.setTitle("갤러리", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemMint
    }
    
    var searchButton = UIButton().then {
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemPink
    }
    
    var titleTextField = DiaryTextField().then {
        $0.setPlaceholder(placeholder: "제목을 입력해주세요.")
    }
    
    var subTitleTextField = DiaryTextField().then {
        $0.setPlaceholder(placeholder: "날짜를 입력해주세요.")
    }
    
    var contentTextView = UITextView().then {
        $0.tintColor = .systemMint
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.backgroundColor = .systemMint
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([imageView,
                                 buttonStackView,
                                 titleTextField,
                                 subTitleTextField,
                                 contentTextView,
                                 saveButton])
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(35)
            make.bottom.equalTo(imageView.snp.bottom).inset(15)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        subTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(subTitleTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
}
