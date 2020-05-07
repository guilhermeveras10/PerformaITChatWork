//
//  MessageCell.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 20/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import SDWebImage

class MessageCell: UICollectionViewCell {
    
    //MARK: - Propeties
    
    var message: Message? {
        didSet {config()}
    }
    
    var messageContainerLeftAnchor: NSLayoutConstraint!
    var messageContainerRightAnchor: NSLayoutConstraint!
    
    private lazy var txtView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        tv.text = " qualquer "
        return tv
    }()
    
    private let profileImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let messageContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImage)
        profileImage.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        profileImage.setDimensions(height: 32, width: 32)
        profileImage.layer.cornerRadius = 32/2
        
        addSubview(messageContainerView)
        messageContainerView.layer.cornerRadius = 12
        messageContainerView.anchor(top: topAnchor, bottom: bottomAnchor)
        messageContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        messageContainerLeftAnchor = messageContainerView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12)
        messageContainerLeftAnchor.isActive = false
        messageContainerRightAnchor = messageContainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        messageContainerRightAnchor.isActive = false
        
        messageContainerView.addSubview(txtView)
        txtView.anchor(top: messageContainerView.topAnchor, left: messageContainerView.leftAnchor, bottom: messageContainerView.bottomAnchor, right: messageContainerView.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helpers
    
    func config() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        
        messageContainerView.backgroundColor = viewModel.messageBackgroundColor
        txtView.textColor = viewModel.textColor
        txtView.text = message.text
        
        messageContainerLeftAnchor.isActive = viewModel.leftAnchorIsActivity
        messageContainerRightAnchor.isActive = viewModel.rightAnchorIsActivity
        
        profileImage.isHidden = viewModel.hideProfileImage
        profileImage.sd_setImage(with: viewModel.profileImageUrl)
    }
}
