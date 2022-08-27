//
//  SearchViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/28.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let searchView = SearchView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        
    }
}
