//
//  SearchViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/28.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - UI Property
    
    private let searchView = SearchView()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    // MARK: - UI Method
    
    private func configureNavigationBar() {
        navigationItem.title = "검색"
        navigationItem.searchController = searchController
    }
    
    private func configureUI() {
        configureNavigationBar()
        configureTableView()
    }
    
    private func setConstraints() {
        
    }
    
    private func configureTableView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        
        searchView.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
    }
}

// MARK: - UITableView Protocol

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.setData("")
        return cell
    }
}
