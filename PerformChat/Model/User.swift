//
//  User.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 20/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let profileImage: String
    let uid: String
    let username: String
    
    init(dictionary: [String : Any]) {
        
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
    }
}
