//
//  ChatViewController.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/05.
//

import UIKit

class ChatViewController: UIViewController {
    
    private enum CellIdentifiers {
        static let chat = "ChatCell"
    }
    
    private var viewModel: ChatViewModel!
    
    lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .gray
        tableView.register(ChatCell.self, forCellReuseIdentifier: CellIdentifiers.chat)
        tableView.estimatedRowHeight = 200
        return tableView
    }()
    
    lazy var chatTextfield: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .roundedRect
        txtField.delegate = self
        return txtField
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Send", for: .normal)
        btn.backgroundColor = .gray
        btn.addTarget(self, action:#selector(self.sendButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel = ChatViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setUpUI() {
        title = user?.login
        view.backgroundColor = .white
        view.addSubview(chatTableView)
        view.addSubview(chatTextfield)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.size.height)! ),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            chatTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chatTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            chatTextfield.topAnchor.constraint(equalTo: chatTableView.bottomAnchor, constant: 20),
            
            sendButton.leadingAnchor.constraint(equalTo: chatTextfield.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sendButton.topAnchor.constraint(equalTo: chatTextfield.topAnchor)
        ])
    }
    
    @objc private func sendButtonClicked() {
        viewModel.sendMessage(text: chatTextfield.text)
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ChatViewController: ChatViewModelDelegate {
    func onSendCompleted(with text: String) {
        chatTextfield.text = ""
        chatTextfield.resignFirstResponder()
        chatTableView.insertRows(at: [IndexPath(row: viewModel.messagesArray.count - 1, section: 0)], with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.receiveMessage()
        }
    }
    
    func onMessageReceived() {
        chatTableView.insertRows(at: [IndexPath(row: viewModel.messagesArray.count - 1, section: 0)], with: .automatic)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.chat, for: indexPath) as? ChatCell else { return UITableViewCell() }
        cell.configure(with: viewModel.messagesArray[indexPath.row], row: indexPath.row)
        return cell
    }
}
