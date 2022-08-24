//
//  MainTableViewCell.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import SnapKit
import Then

class MainTableViewCell: UITableViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .boldSystemFont(ofSize: 13)
    }
    
    private var contentLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .boldSystemFont(ofSize: 11)
    }
    
    private var dateLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 11)
    }
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "YY.MM.dd"
    }
    
    private var contentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
        contentView.addSubviews([titleLabel, contentLabel, dateLabel, contentImageView])
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    // MARK: - Data Binding
    
    func setData(_ data: UserDiary) {
        titleLabel.text = data.diaryTitle
        
        contentLabel.text = data.diaryContent
    
        dateLabel.text =  dateFormatter.string(from: data.diaryDate)
    }
}
