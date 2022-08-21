//
//  ImageSearchView.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

final class ImageSearchView: BaseView {
    
    // MARK: - UI Property
    
    var searchBar = UISearchBar().then {
        $0.placeholder = "오늘의 기분에 맞는 짤을 찾아볼까요?"
    }
    
    var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = .zero
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
        }
    }()
    
    // MARK: - UI Method
    
    override func configureUI() {
        addSubviews([searchBar, imageCollectionView])
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(47)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
