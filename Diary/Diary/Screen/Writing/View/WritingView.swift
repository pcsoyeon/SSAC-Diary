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
    
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .systemGray5
    }
    
    var searchButton = UIButton().then {
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.orange, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    var titleTextField = DiaryTextField().then {
        $0.setPlaceholder(placeholder: "제목을 입력해주세요.")
    }
    
    var subTitleTextField = DiaryTextField().then {
        $0.setPlaceholder(placeholder: "소제목을 입력해주세요.")
    }
    
    var contentTextView = UITextView().then {
        $0.tintColor = .systemMint
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        addSubviews([imageView,
                     titleTextField,
                     subTitleTextField,
                     contentTextView,
                     searchButton])
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(250)
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(35)
            make.bottom.equalTo(imageView.snp.bottom).inset(15)
            make.width.equalTo(55)
            make.height.equalTo(30)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        subTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(subTitleTextField.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(250)
        }
    }
}
