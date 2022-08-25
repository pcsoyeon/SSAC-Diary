//
//  ImageCollectionViewCell.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

import Kingfisher
import SnapKit
import Then

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Property
    
    var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    // MARK: - Property
    
    var selectedIndexPath: IndexPath?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = UIColor.systemMint.cgColor
                contentView.layer.borderWidth = 3
            } else {
                contentView.layer.borderWidth = 0
            }
        }
    }
        
    
    // MARK: - UI Method
    
    private func configureUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Data Binding
    
    func setData(_ data: String) {
        let url = URL(string: data)
        imageView.kf.setImage(with: url)
    }
}
