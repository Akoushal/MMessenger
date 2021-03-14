//
//  ViewController.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/01.
//

import UIKit

class ViewController: UIViewController, AlertDisplayer {
    
    private enum CellIdentifiers {
        static let list = "UserListCell"
    }
    
    private var viewModel: UsersListViewModel!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let actIndicator = UIActivityIndicatorView()
        actIndicator.translatesAutoresizingMaskIntoConstraints = false
        return actIndicator
    }()
    
    lazy var usersListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .gray
        tableView.register(UserListCell.self, forCellReuseIdentifier: CellIdentifiers.list)
        tableView.rowHeight = 100
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI
        setUpUI()
        // Fetch Manufacturer List
        let request = UsersAPIRequest.parameterizedRequest()
        viewModel = UsersListViewModel(request: request, delegate: self)
        viewModel.fetchUsers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Deselect selected cell when view disappears
        for indexPath in usersListTableView.indexPathsForSelectedRows ?? [] {
            usersListTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpUI() {
        title = "GitHub DM"
        view.addSubview(usersListTableView)
        view.addSubview(activityIndicator)
        usersListTableView.edgesAnchorEqualTo(destinationView: view).activate()
        activityIndicator.startAnimating()
        usersListTableView.isHidden = true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as? UserListCell else { return UITableViewCell() }
        // 2
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.user(at: indexPath.row))
        }
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchUsers()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.user = viewModel.user(at: indexPath.row)
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension ViewController: UsersListViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activityIndicator.stopAnimating()
            usersListTableView.isHidden = false
            usersListTableView.reloadData()
            return
        }
        // 2
        usersListTableView.insertRows(at: newIndexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        activityIndicator.stopAnimating()
        
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

private extension ViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount - 1
    }
}
