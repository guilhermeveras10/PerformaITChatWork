//
//  AuthService.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 19/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct RegistrationCredential {
    let email: String
    let pwd: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func loginUser (email: String, pwd: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: pwd, completion: completion)
    }
    
    func registerUser(credentials: RegistrationCredential, completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        ref.putData(imageData, metadata: nil){(meta,error) in
            if let error = error {
                completion!(error)
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {return}
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.pwd) { (response, error) in
                    if let error = error {
                        completion!(error)
                        return
                    }
                    guard let uid = response?.user.uid else {return}
                    
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "username": credentials.username,
                                "profileImage": profileImageUrl,
                                "uid": uid] as [String : Any]
                    COLLECTION_USERS.document(uid).setData(data,completion: completion)
                    
                }
            }
        }
    }
}
