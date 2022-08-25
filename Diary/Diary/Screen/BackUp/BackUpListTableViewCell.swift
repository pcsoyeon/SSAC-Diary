//
//  BackUpListTableViewCell.swift
//  Diary
//
//  Created by 소연 on 2022/08/25.
//

import UIKit

class BackUpListTableViewCell: UITableViewCell {
    
    private var label = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 15)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
    }
    
    private func setConstraints() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
}
