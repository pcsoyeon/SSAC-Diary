//
//  BaseViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    func configure() { }
    
    func showAlertMessage(title: String,
                          leftButtonTitle: String,
                          rightButtonTitle: String,
                          leftButtonAction: @escaping (UIAlertAction) -> (),
                          rightButtonAction: @escaping (UIAlertAction) -> ()) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let leftButton = UIAlertAction(title: leftButtonTitle, style: .default, handler: leftButtonAction)
        let rightButton = UIAlertAction(title: rightButtonTitle, style: .default, handler: rightButtonAction)
        alert.addAction(leftButton)
        alert.addAction(rightButton)
        present(alert, animated: true)
    }
}
