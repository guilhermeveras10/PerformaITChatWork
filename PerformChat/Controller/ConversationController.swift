//
//  ConversationController.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 17/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationController: UIViewController {
    
    //MARK: - Propeties
    
    private let tableView = UITableView()
    private var conversations = [Coversation]()
    
    private let conversationBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.backgroundColor = .systemPurple
        btn.tintColor = .white
        btn.setDimensions(height: 56, width: 56)
        btn.layer.cornerRadius = 56/2
        btn.imageView?.setDimensions(height: 24, width: 24)
        btn.addTarget(self, action: #selector(newConversationScreen), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        authenticateUsers()
        retrieve()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Conversas", prefersLargeTitles: true)
    }
    
    //MARK: - API
    
    func retrieve () {
        Service.retrieveConversations { conversations in
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
    
    func authenticateUsers() {
        if Auth.auth().currentUser?.uid == nil {
            presentLogin()
        } else {
            print("usuario logado")
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            presentLogin()
        } catch {
            self.showError("error to Log Out")
        }
    }
    
    //MARK: - Selectors
    
    @objc func showProfile() {
        logOut()
    }
    
    @objc func newConversationScreen() {
        let controller = SearchConversationController()
        controller.delegate = self
        presentRoot(controller: controller)
    }
    
    //MARK: - Helpers
    
    func presentRoot(controller: UIViewController) {
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func presentLogin() {
        DispatchQueue.main.async {
            let controller = LoginController()
            self.presentRoot(controller: controller)
        }
    }
    
    func configureInterface() {
        view.backgroundColor = .white
        
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(conversationBtn)
        conversationBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ConversationController: UITableViewDataSource {
    
    //MARK: - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationsCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}
extension ConversationController: UITableViewDelegate {
    
    //MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
}

extension ConversationController: SearchConversationDelegate {
    
    //MARK: - SearchUser Delegate
    
    func controller(_controller: SearchConversationController, user: User) {
        dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
    }
}
