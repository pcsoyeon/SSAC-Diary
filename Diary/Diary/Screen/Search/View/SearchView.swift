//
//  SearchView.swift
//  Diary
//
//  Created by 소연 on 2022/08/28.
//

import UIKit

import SnapKit
import Then

final class SearchView: BaseView {
    
    // MARK: - UI Property
    
    var tableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = .white
    }
    
    override func setConstraints() {
        addSubviews([tableView])
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
