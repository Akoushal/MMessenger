//
//  UsersListViewModel.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/02.
//

import Foundation

protocol UsersListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class UsersListViewModel {
    private weak var delegate: UsersListViewModelDelegate?
    
    private var users: [User] = []
    private var currentPage = 0
    private var total = 0
    private var isFetchInProgress = false
    
    let client = UsersAPIClient()
    let request: UsersAPIRequest
    
    init(request: UsersAPIRequest, delegate: UsersListViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return users.count
    }
    
    var lastFetchedUserId: Int? {
        return users.last?.id
    }
    
    func user(at index: Int) -> User {
        return users[index]
    }
    
    func fetchUsers() {
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        // 2
        isFetchInProgress = true
        
        client.fetchUsers(with: request, since: lastFetchedUserId ?? 0) { result in
            switch result {
            // 3
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            // 4
            case .success(let response):
                DispatchQueue.main.async {
                    // 1
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    // 2
                    self.users.append(contentsOf: response)
                    self.total = self.users.count
                    // 3
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newUsers: [User]) -> [IndexPath] {
        let startIndex = users.count - newUsers.count
        let endIndex = startIndex + newUsers.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
