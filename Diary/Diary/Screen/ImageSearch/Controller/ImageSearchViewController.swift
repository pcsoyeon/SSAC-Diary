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
    
    private var startPage: Int = 1
    private var totalCount: Int = 0
    
    private var imageList: [String] = []
    
    private var isImageSelected: Bool = false
    private var selectedImage: String = ""
    
    var doneButtonActionHandler: ((String?) -> ())?

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
        configureNavigationBar()
    }
    
    // MARK: - Custom Method
    
    private func configureCollectionView() {
        imageSearchView.imageCollectionView.delegate = self
        imageSearchView.imageCollectionView.dataSource = self
        imageSearchView.imageCollectionView.prefetchDataSource = self
        
        imageSearchView.imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }
    
    private func configureSearchBar() {
        imageSearchView.searchBar.delegate = self
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton))
    }
    
    // MARK: - @objc
    
    @objc func touchUpDoneButton() {
        if isImageSelected {
            doneButtonActionHandler?(selectedImage)
            self.navigationController?.popViewController(animated: true)
        } else {
            showAlertMessage(title: "이미지를 선택하지 않았어요!",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "나가기") { _ in
                
            } rightButtonAction: { _ in
                self.navigationController?.popViewController(animated: true)
            }

        }
    }
}

// MARK: - UICollectionView Protocol

extension ImageSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else {
            return true
        }
        
        if cell.isSelected {
            isImageSelected = false
            collectionView.deselectItem(at: indexPath, animated: false)
            return false
        } else {
            isImageSelected = true
            selectedImage = imageList[indexPath.item]
            return true
        }
    }
}

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
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(imageList[indexPath.item])
        return cell
    }
}

extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if imageList.count - 1 == indexPath.item && imageList.count < totalCount {
                startPage += 15
                callRequest(keyword: imageSearchView.searchBar.text!)
            }
        }
    }
}

// MARK: - UISearchBar Protocol

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            startPage = 1
            imageList.removeAll()
            
            imageSearchView.imageCollectionView.scrollsToTop = true
            
            callRequest(keyword: text)
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
    private func callRequest(keyword: String) {
        SearchAPIManger.shared.fetchImage(keyword: keyword, startPage: startPage) { imageList, totalCount in
            self.imageList.append(contentsOf: imageList)
            self.totalCount = totalCount
            self.imageSearchView.imageCollectionView.reloadData()
        }
    }
}
