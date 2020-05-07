//
//  ConversationsCell.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 21/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import SDWebImage

class ConversationsCell: UITableViewCell {
    
    //MARK: - Propeties
    
    private let profileImage: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let timestampLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "apelido label"
        return label
    }()
    
    private let messageLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "nome label"
        return label
    }()
    
    var conversation: Coversation? {
        didSet {config()}
    }
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        profileImage.anchor(left: leftAnchor, paddingLeft: 12)
        profileImage.setDimensions(height: 50, width: 50)
        profileImage.layer.cornerRadius = 50 / 2
        profileImage.centerY(inView: self)
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,messageLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImage)
        stack.anchor(left: profileImage.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func config() {
        guard let conversation = conversation else { return }
        let viewModel = ConversationViewModel(conversation: conversation)
        
        usernameLabel.text = conversation.user.username
        messageLabel.text = conversation.message.text
        
        timestampLabel.text = viewModel.timestamp
        profileImage.sd_setImage(with: viewModel.profileImageUrl)
    }
}
