//
//  ConversationViewModel.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 21/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Coversation
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImage)
    }
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Coversation) {
        self.conversation = conversation
    }
}
