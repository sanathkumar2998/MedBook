//
//  HomeViewController.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayLogoutActionSuccessful(viewModel: Home.Logout.ViewModel)
    func displayBooksData(viewModel: Home.Search.ViewModel)
    func displayPaginatedData(viewModel: Home.Search.ViewModel)
}

class HomeViewController: UIViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var sortByTitleButton: UIButton!
    @IBOutlet private var sortByAverageButton: UIButton!
    @IBOutlet private var sortByHitsButton: UIButton!
    @IBOutlet private var sortOptionsView: UIView!
    @IBOutlet private var tableView: UITableView!
        
    private var interactor: HomeBusinessLogic?
    private var router: HomeRouter?
    
    private var books: [BookViewModel] = [] {
        didSet {
            toggleTableFooterView(show: false)
            tableView.reloadData()
            toggleSortOptionsView(show: !books.isEmpty)
        }
    }
    
    enum SortType {
        case title
        case average
        case hits
        case none
    }
    
    private lazy var paginationIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        return spinner
    }()
    
    private let rowHeight: CGFloat = 128
    
    // MARK: Injection
    
    func setInteractor(interactor: HomeBusinessLogic?) {
        self.interactor = interactor
    }
    
    func setRouter(router: HomeRouter?) {
        self.router = router
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: IBAction
    
    @IBAction func handleLogoutAction() {
        interactor?.handleLogoutAction(request: Home.Logout.Request())
    }
    
    @IBAction func handleSortByTitleAction() {
        updateButtonsUI(sortType: .title)
        handleSort(sortType: .title)
    }
    
    @IBAction func handleSortByAverageAction() {
        updateButtonsUI(sortType: .average)
        handleSort(sortType: .average)
    }
    
    @IBAction func handleSortByHitsAction() {
        updateButtonsUI(sortType: .hits)
        handleSort(sortType: .hits)
    }
}

// MARK: - Private methods

private extension HomeViewController {
    func setup() {
        setupButtons()
        setupTableView()
    }
    
    func setupButtons() {
        sortByTitleButton.layer.cornerRadius = 12
        sortByAverageButton.layer.cornerRadius = 12
        sortByHitsButton.layer.cornerRadius = 12
    }
    
    func setupTableView() {
        tableView
            .register(UINib(nibName: HomeSceneConstants.bookTableViewCell,
                            bundle: .main),
                      forCellReuseIdentifier: HomeSceneConstants.bookTableViewCell)
    }
    
    func updateButtonsUI(sortType: SortType) {
        switch sortType {
        case .title:
            sortByTitleButton.backgroundColor = .lightGray
            sortByAverageButton.backgroundColor = .clear
            sortByHitsButton.backgroundColor = .clear
        case .average:
            sortByAverageButton.backgroundColor = .lightGray
            sortByTitleButton.backgroundColor = .clear
            sortByHitsButton.backgroundColor = .clear
        case .hits:
            sortByHitsButton.backgroundColor = .lightGray
            sortByTitleButton.backgroundColor = .clear
            sortByAverageButton.backgroundColor = .clear
        case .none:
            sortByHitsButton.backgroundColor = .clear
            sortByTitleButton.backgroundColor = .clear
            sortByAverageButton.backgroundColor = .clear
        }
    }
    
    func handleSort(sortType: SortType) {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        switch sortType {
        case .title:
            books.sort { $0.title < $1.title }
        case .average:
            books.sort { Float($0.ratingsAverage) ?? 0 > Float($1.ratingsAverage) ?? 0 }
        case .hits:
            books.sort { Int($0.ratingsCount) ?? 0 > Int($1.ratingsCount) ?? 0 }
        case .none:
            break
        }
    }
    
    func toggleTableFooterView(show: Bool) {
        if show {
            tableView.tableFooterView = paginationIndicatorView
            tableView.tableFooterView?.isHidden = false
            paginationIndicatorView.startAnimating()
        } else {
            tableView.tableFooterView = nil
            tableView.tableFooterView?.isHidden = true
            paginationIndicatorView.stopAnimating()
        }
    }
    
    func toggleSortOptionsView(show: Bool) {
        sortOptionsView.isHidden = !show
        if !show {
            updateButtonsUI(sortType: .none)
        }
    }
}

// MARK: - HomeDisplayLogic

extension HomeViewController: HomeDisplayLogic {
    func displayLogoutActionSuccessful(viewModel: Home.Logout.ViewModel) {
        router?.navigate(to: .landing)
    }
    
    func displayBooksData(viewModel: Home.Search.ViewModel) {
        if let searchText = searchBar.text,
           searchText.count > 2 {
            books = viewModel.books
        }
    }
    
    func displayPaginatedData(viewModel: Home.Search.ViewModel) {
        books.append(contentsOf: viewModel.books)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: HomeSceneConstants.bookTableViewCell,
                                 for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        
        let data = books[indexPath.row]
        cell.data = data
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        
        let position = scrollView.contentOffset.y
        if position > (scrollView.contentSize.height - scrollView.frame.height - 100) {
            // If scroll has reached the end of contents, call API for pagination.
            toggleTableFooterView(show: true)
            let request = Home.Search.Request(searchText: searchBar.text ?? "",
                                              fetchType: .pagination)
            interactor?.searchBooks(request: request)
        }
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            let request = Home.Search.Request(searchText: searchText,
                                              fetchType: .initial)
            interactor?.searchBooks(request: request)
        } else {
            books = []
        }
        updateButtonsUI(sortType: .none)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
