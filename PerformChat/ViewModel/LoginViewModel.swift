//
//  LoginViewModel.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 19/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool {get}
}
struct LoginViewModel {
    var email: String?
    var pwd: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && pwd?.isEmpty == false
    }
}
