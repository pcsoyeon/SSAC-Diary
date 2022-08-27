//
//  SearchViewController.swift
//  Diary
//
//  Created by 소연 on 2022/08/28.
//

import UIKit

import RealmSwift

final class SearchViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let searchView = SearchView()
    
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchResultsUpdater = self
    }
    
    // MARK: - Property
    
    private let repository = UserDiaryRepository()
    
    private var tasks: Results<UserDiary>! {
        didSet {
            searchView.tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRealmData()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "검색"
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "찾고 싶은 일기 제목을 검색해보세요"
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        
        searchView.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Custom Method
    
    private func fetchRealmData() {
        tasks = repository.fetch()
    }
}

// MARK: - UITableView Protocol

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.setData(tasks[indexPath.row].diaryTitle)
        return cell
    }
}

// MARK: - UISearchBar Protocol

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        tasks = repository.fetchFilter(text)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        fetchRealmData()
    }
}
