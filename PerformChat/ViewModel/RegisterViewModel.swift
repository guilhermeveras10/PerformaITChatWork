//
//  RegisterViewModel.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 19/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation

struct RegisterViewModel: AuthenticationProtocol {
    
    var email: String?
    var pwd: String?
    var fullname: String?
    var usename: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && pwd?.isEmpty == false && fullname?.isEmpty == false && usename?.isEmpty == false
    }
}
