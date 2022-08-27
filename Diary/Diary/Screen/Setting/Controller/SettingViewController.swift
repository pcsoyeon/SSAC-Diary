//
//  SettingViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/28.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let settingView = SettingView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        
    }
    
    private func configureTableView() {
        
    }
}
