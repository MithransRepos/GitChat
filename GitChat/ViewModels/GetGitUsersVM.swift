//
//  GetGitUsersVM.swift
//  GitChat
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import Foundation

public protocol GetGitUsersVMDelegate: class {
    func didFetchUsers()
    func didFailFetchUsers(errorMessage: String)
    func apiCallInProgress()
    func apiCallCompleted()
}
class GetGitUsersVM: NSObject {
    
    private let userDataManager: UserDataManager = UserDataManager()
    private var users: [User] = []
    private weak var delegate: GetGitUsersVMDelegate?
    
    init(delegate: GetGitUsersVMDelegate) {
        super.init()
        self.delegate = delegate
        getUsers()
    }
    
    // Get git user from API
    private func getUsers() {
        delegate?.apiCallInProgress()
        userDataManager.getUsers { [weak self]result in
            switch result {
            case .success(let users):
                guard let users = users, let self = self else {
                    return
                }
                self.users = users
                self.delegate?.didFetchUsers()
            case .failure(let error):
                self?.delegate?.didFailFetchUsers(errorMessage: error.localizedDescription)
            }
            self?.delegate?.apiCallCompleted()
        }
    }
}
// MARK: GitUsersListVCDataSource functions
extension GetGitUsersVM: GitUsersListVCDataSource {
    func getNumberOfUsers() -> Int {
        return users.count
    }
    
    func getUserDetails(at index: Int) -> User? {
        return users[safeIndex: index]
    }
}
