//
//  SearchTableViewCell.swift
//  Diary
//
//  Created by 소연 on 2022/08/28.
//

import UIKit

import SnapKit
import Then

final class SearchTableViewCell: UITableViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "검색"
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 15)
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setConstraints() {
        contentView.addSubviews([titleLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func setData(_ data: String) {
        titleLabel.text = data
    }
}
