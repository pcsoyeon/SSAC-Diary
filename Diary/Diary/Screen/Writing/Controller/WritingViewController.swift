//
//  WritingViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import UIKit
import PhotosUI

import Kingfisher
import RealmSwift // 1.
import SnapKit
import Then

final class WritingViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private var writingView = WritignView()
    
    // MARK: - Property
    
    private let localRealm = try! Realm() // 2.
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY.MM.dd"
    }
    
    private lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = writingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at: ", localRealm.configuration.fileURL!)
    }
    
    // MARK: - UI Method
    
    override func configure() {
        title = "글쓰기"
        configureNavigationBar()
        configureButton()
        configureTextField()
        configureTextView()
        setToolBar()
        configureDatePickerView()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(touchUpCancelButton))
    }
    
    private func configureButton() {
        writingView.galleryButton.addTarget(self, action: #selector(touchUpGalleryButton), for: .touchUpInside)
        writingView.searchButton.addTarget(self, action: #selector(touchUpSearchButton), for: .touchUpInside)
        writingView.saveButton.addTarget(self, action: #selector(touchUpSaveButton), for: .touchUpInside)
    }
    
    private func configureTextField() {
        writingView.titleTextField.delegate = self
        writingView.subTitleTextField.delegate = self
        
        writingView.subTitleTextField.inputView = datePicker
    }
    
    private func configureTextView() {
        writingView.contentTextView.delegate = self
    }
    
    private func setToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.backgroundColor = .systemGray6
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(touchUpDoneButton))
        toolBar.items = [flexibleSpace, doneButton]
        
        writingView.titleTextField.inputAccessoryView = toolBar
        writingView.contentTextView.inputAccessoryView = toolBar
    }
    
    private func configureDatePickerView() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.backgroundColor = .systemGray6
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(touchUpDateDoneButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        writingView.subTitleTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - @objc
    
    @objc func touchUpGalleryButton() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func touchUpSearchButton() {
        let viewController = ImageSearchViewController()
        viewController.doneButtonActionHandler = { imagURL in
            guard let url = imagURL else { return }
            self.writingView.imageView.kf.setImage(with: URL(string: url))
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Realm + 이미지 도큐먼트 저장
    @objc func touchUpSaveButton() {
        guard let title = writingView.titleTextField.text else { return }
        guard let diaryDate = writingView.subTitleTextField.text else { return }
        guard let context = writingView.contentTextView.text else { return }
        
        if title == "" || diaryDate == "" || context == "" {
            showAlertMessage(title: "내용을 모두 작성하지 않았어요!",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "나가기") { _ in
            } rightButtonAction: { _ in
                self.dismiss(animated: true)
            }
        } else {
            let task = UserDiary(diaryTitle: title,
                                 diaryContent: context,
                                 diaryDate: dateFormatter.date(from: diaryDate) ?? Date(),
                                 regDate: Date(),
                                 photo: nil)
            
            do {
                try localRealm.write {
                    localRealm.add(task)
                }
            } catch let error {
                print(error)
            }
            
            // 이미지를 저장해야하는 상황에서만 저장 
            if let image = writingView.imageView.image {
                saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
            }
            
            dismiss(animated: true)
        }
    }
    
    @objc func touchUpCancelButton() {
        showAlertMessage(title: "작성 중에 나가면 저장이 되지 않아요",
                         leftButtonTitle: "취소",
                         rightButtonTitle: "나가기") { _ in
        } rightButtonAction: { _ in
            self.dismiss(animated: true)
        }
    }
    
    @objc func touchUpDoneButton() {
        view.endEditing(true)
    }
    
    @objc func touchUpDateDoneButton() {
        writingView.subTitleTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}

// MARK: - UITextField Protocol

extension WritingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemMint.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        return true
    }
}

// MARK: - UITextView Protocol

extension WritingViewController: UITextViewDelegate {
    
}

// MARK: - PHPicker Protocol

extension WritingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else {
            return
        }
        
        let imageResult = results[0]
        
        if let assetId = imageResult.assetIdentifier {
            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            DispatchQueue.main.async {
                if let date = assetResults.firstObject?.creationDate {
                    self.writingView.subTitleTextField.text = self.dateFormatter.string(from: date)
                }
            }
        }
        if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.writingView.imageView.image = selectedImage as? UIImage
                    }
                }
                
            }
        }
    }
}
