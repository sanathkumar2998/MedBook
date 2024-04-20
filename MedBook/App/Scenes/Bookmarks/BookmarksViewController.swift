//
//  BookmarksViewController.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol BookmarksDisplayLogic: AnyObject {
    func displayBookmarks(viewModel: Bookmarks.Model.ViewModel)
    func displayRemoveBookmarkSuccess(viewModel: Bookmarks.RemoveBookmark.ViewModel)
}

protocol RemoveBookmarkDelegate: AnyObject {
    func bookmarkRemoved(key: String?)
}

class BookmarksViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
        
    private var interactor: BookmarksBusinessLogic?
    private var router: BookmarksRouter?
    private weak var delegate: RemoveBookmarkDelegate?
    
    private var books: [BookViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let rowHeight: CGFloat = 128
    
    // MARK: Injection
    
    func setInteractor(interactor: BookmarksBusinessLogic?) {
        self.interactor = interactor
    }
    
    func setRouter(router: BookmarksRouter?) {
        self.router = router
    }
    
    func setDelegate(_ delegate: RemoveBookmarkDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetchBookmarks()
    }
}

// MARK: - Private methods

private extension BookmarksViewController {
    func setup() {
        setupNavBarBackButton()
        setupTableView()
    }
    
    func setupNavBarBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: BookmarksStringConstants.chevronLeftImageName),
                                         style: .plain,
                                         target: self,
                                         action: nil)
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupTableView() {
        tableView
            .register(UINib(nibName: BookmarksSceneConstants.bookTableViewCell,
                            bundle: .main),
                      forCellReuseIdentifier: BookmarksSceneConstants.bookTableViewCell)
    }
    
    func fetchBookmarks() {
        interactor?.fetchBookmarks(request: Bookmarks.Model.Request())
    }
    
    func removeBookmark(indexPath: IndexPath) {
        let request = Bookmarks.RemoveBookmark.Request(key: books[indexPath.row].key)
        interactor?.removeBookmark(request: request)
    }
    
    func removeBookWithKey(key: String?) {
        let index = books.firstIndex { $0.key == key } ?? 0
        books.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        delegate?.bookmarkRemoved(key: key)
    }
}

// MARK: - BookmarksDisplayLogic

extension BookmarksViewController: BookmarksDisplayLogic {
    func displayBookmarks(viewModel: Bookmarks.Model.ViewModel) {
        books = viewModel.books
    }
    
    func displayRemoveBookmarkSuccess(viewModel: Bookmarks.RemoveBookmark.ViewModel) {
        removeBookWithKey(key: viewModel.key)
    }
}

// MARK: - UITableViewDataSource

extension BookmarksViewController: UITableViewDataSource {
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

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view,
            completion in
            guard let self else { return }
            
            self.removeBookmark(indexPath: indexPath)
            completion(true)
        }
        
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let imageName: String
        if books[indexPath.row].isBookmarked {
            imageName = BookmarksStringConstants.bookmarkFillImageName
        } else {
            imageName = BookmarksStringConstants.bookmarkImageName
        }
        
        let image = UIImage(systemName: imageName,
                            withConfiguration: sizeConfig)?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        bookmarkAction.image = image
        bookmarkAction.backgroundColor = .systemGray6
        let configuration = UISwipeActionsConfiguration(actions: [bookmarkAction])
        return configuration
    }
}
