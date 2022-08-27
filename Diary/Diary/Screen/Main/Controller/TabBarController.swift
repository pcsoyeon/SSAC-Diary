//
//  TabBarController.swift
//  Diary
//
//  Created by 소연 on 2022/08/28.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        setTabBarAppearence()
    }
    
    // MARK: - UI Method
    
    private func configureTabBarController() {
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        mainViewController.tabBarItem.title = "메인"
        mainViewController.tabBarItem.image = UIImage(systemName: "house")
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem.title = "검색"
        searchViewController.tabBarItem.image = UIImage(systemName: "star")
        
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem.title = "설정"
        settingViewController.tabBarItem.image = UIImage(systemName: "tray")
        
        setViewControllers([mainViewController, searchViewController, settingViewController], animated: true)
    }
    
    private func setTabBarAppearence() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemBlue
    }
}

// MARK: - UITabBarController Delegate

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }
}
