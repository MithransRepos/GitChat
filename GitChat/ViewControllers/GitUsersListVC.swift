//
//  ViewController.swift
//  GitChat
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import UIKit

// MARK: DataSource protocol for GitUsersListVC
public protocol GitUsersListVCDataSource: class {
    func getNumberOfUsers() -> Int
    func getUserDetails(at index: Int) -> User?
}

class GitUsersListVC: BaseViewController {
    private var dataSource: GitUsersListVCDataSource!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let vm = GetGitUsersVM(delegate: self)
        dataSource = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GitHub DM"
    }
    
    override func addViews() {
        super.addViews()
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        tableView.set(.fillSuperView(self.view))
    }
    
    override func setupTableView()  {
        super.setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GitUserTVCell.self, forCellReuseIdentifier: GitUserTVCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }


}

// MARK: tableview delegate & dataSource functions
extension GitUsersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getNumberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GitUserTVCell = tableView.dequeueReusableCell(withIdentifier: GitUserTVCell.reuseIdentifier,
                                                                      for: indexPath) as? GitUserTVCell else {
                                                                        return UITableViewCell()
        }
        let cellDataSource = GitUserTVCellVM(user: dataSource.getUserDetails(at: indexPath.row))
        cell.accessoryType = .disclosureIndicator
        cell.setDataSource(cellDataSource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatThreadVC = GitUserDmThreadVC(user: dataSource.getUserDetails(at: indexPath.row))
        self.navigationController?.pushViewController(chatThreadVC, animated: true)
    }
    
}

// MARK: GetGitUsersVMDelegate functions
extension GitUsersListVC: GetGitUsersVMDelegate {
    func didFailFetchUsers(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didFetchUsers() {
        tableView.reloadData()
    }
    
    func didFailFetchUsers() {
        tableView.reloadData()
    }
    
    
}
