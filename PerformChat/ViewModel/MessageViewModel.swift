//
//  MessageViewModel.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 20/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : .systemPurple
    }
    
    var textColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorIsActivity: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorIsActivity: Bool {
        return !message.isFromCurrentUser
    }
    
    var hideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImage)
    }
    
    
    init(message: Message) {
        self.message = message
    }
}
