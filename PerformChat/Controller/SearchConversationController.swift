//
//  searchNewConversation.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 19/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ConversationCell"

protocol SearchConversationDelegate: class {
    func controller(_controller: SearchConversationController, user: User)
}
        
class SearchConversationController: UITableViewController {
    
    //MARK: - Propeties
    
    private var users = [User]()
    weak var delegate: SearchConversationDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        retrieveDataUsers() 
    }
    
    //MARK: - Selectors
    
    @objc func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API
    
    func retrieveDataUsers() {
        Service.retrieveUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        configureNavigationBar(withTitle: "Procurar usuarios", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissScreen))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    
}

extension SearchConversationController {
    
    //MARK: - TableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}

extension SearchConversationController {
    
    //MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(_controller: self, user: users[indexPath.row])
    }
}

