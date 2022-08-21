//
//  DiaryTextField.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import SnapKit
import Then

class DiaryTextField: UITextField {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDefaultStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureDefaultStyle() {
        self.font = .systemFont(ofSize: 15)
        self.backgroundColor = .white
        self.tintColor = .systemMint
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.setLeftPaddingPoints(12)
        self.setRightPaddingPoints(12)
    }
    
    func setPlaceholder(placeholder: String) {
        self.placeholder = placeholder
    }
}

