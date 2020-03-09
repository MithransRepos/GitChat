//
//  GitUserDmThreadVC.swift
//  GitChat
//
//  Created by MithranN on 12/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import UIKit

// MARK: DataSource protocol for GitUserDmThreadVC
public protocol GitUserDmThreadVCDataSource: class {
    func getNumberOfMessages() -> Int
    func getMessage(at index: Int) -> Message?
    func sendMessage(text: String?)
    func viewWillDisappear()
}

class GitUserDmThreadVC: BaseViewController {
    
    private var dataSource: GitUserDmThreadVCDataSource!
    
    private let textField: UITextField  = {
        let textField = UITextField()
        textField.layer.cornerRadius = 36/2
        textField.backgroundColor = .white
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        textField.returnKeyType = .done
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(Padding.p8, 0, 0)
        return textField
    }()
    private let sendButton: UIButton  = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Send", for: .normal)
        return button
    }()
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    init(user: User?) {
        super.init(nibName: nil, bundle: nil)
        dataSource = GitUserDmThreadVM(delegate: self, userId: user?.login)
        if let userId = user?.login {
            title = "@\(userId)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewSendButton()
        textField.delegate = self
    }
    
    override func addViews() {
        super.addViews()
        view.addSubview(bottomView)
        view.addSubview(seperatorView)
        bottomView.addSubview(sendButton)
        bottomView.addSubview(textField)
    }
    
    override func setConstraints() {
        bottomView.set(.bottom(self.view, Padding.p12), .sameLeadingTrailing(self.view), .height(52))
        seperatorView.set(.above(bottomView),.height(0.5), .sameLeadingTrailing(self.view))
        tableView.set(.above(seperatorView), .top(self.view), .sameLeadingTrailing(self.view))
        sendButton.set(.trailing(bottomView), .sameTopBottom(bottomView,Padding.p12))
        textField.set(.leading(bottomView, Padding.p12), .before(sendButton, Padding.p12), .sameTopBottom(bottomView,Padding.p8),
                      .width(UIScreen.main.bounds.width - 100))
    }
    
    override func setupTableView()  {
        super.setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GitUserChatTVCell.self, forCellReuseIdentifier: GitUserChatTVCell.reuseIdentifier)
        tableView.separatorStyle = .none
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Padding.p10))
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
    }
    
    private func setupViewSendButton() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }

    @objc func sendButtonTapped() {
        dataSource.sendMessage(text: textField.text)
        textField.text = nil
        view.endEditing(false)
    }

    override func keyboardWillAppear(withKeyboardHeight: CGFloat) {
        super.keyboardWillAppear(withKeyboardHeight: withKeyboardHeight)
        bottomView.get(.bottom)?.constant = -(withKeyboardHeight)
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillDisappear() {
        super.keyboardWillDisappear()
        bottomView.get(.bottom)?.constant =  -Padding.p12
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dataSource.viewWillDisappear()
    }
}

// MARK: tableview delegate & dataSource functions
extension GitUserDmThreadVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getNumberOfMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GitUserChatTVCell = tableView.dequeueReusableCell(withIdentifier: GitUserChatTVCell.reuseIdentifier,
                                                                      for: indexPath) as? GitUserChatTVCell else {
                                                                        return UITableViewCell()
        }
        
        cell.setDataSource(GitUserChatTVCellVM(message: dataSource.getMessage(at: indexPath.row)))
        return cell
    }
}

// MARK: GitUserDmThreadVMDelegate functions
extension GitUserDmThreadVC: GitUserDmThreadVMDelegate {
    func reloadView() {
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.tableView.scrollToBottom()
        }
    }
}

// MARK: UITextFieldDelegate functions
extension GitUserDmThreadVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return false
    }
}
