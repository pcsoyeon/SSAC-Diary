//
//  ImageSearchViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

final class ImageSearchViewController: BaseViewController {
    
    // MARK: - UI Property
    
    let imageSearchView = ImageSearchView()
    
    // MARK: - Property
    
    private var currentPage: Int = 1
    private var totalPage: Int = 0

    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = imageSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        configureCollectionView()
        configureSearchBar()
    }
    
    // MARK: - Custom Method
    
    private func configureCollectionView() {
        imageSearchView.imageCollectionView.delegate = self
        imageSearchView.imageCollectionView.dataSource = self
        
        imageSearchView.imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }
    
    private func configureSearchBar() {
        imageSearchView.searchBar.delegate = self
    }
}

// MARK: - UICollectionView Protocol

extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 40) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10)
    }
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

// MARK: - UISearchBar Protocol

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            callRequest(keyword: text, page: 1)
        }
        
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imageSearchView.imageCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

// MARK: - Network

extension ImageSearchViewController {
    private func callRequest(keyword: String, page: Int = 1) {
        SearchAPIManger.shared.fetchImage(keyword: keyword, page: page) {
            
        }
    }
}
