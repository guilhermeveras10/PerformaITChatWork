//
//  Service.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 20/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Firebase

struct Service {
    static func retrieveUsers(completion: @escaping([User])->Void) {
        var users = [User]()
        COLLECTION_USERS.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func retrieveUser(uid: String, completion: @escaping(User)->Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func retrieveConversations(completion: @escaping([Coversation]) -> Void) {
        var conversations = [Coversation]()
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_MESSAGES.document(currentUID).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.retrieveUser(uid: message.toId) { user in
                    
                    let conversation = Coversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
                
            })
        }
    }
    
    static func retrieveMessagers(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_MESSAGES.document(currentUID).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, toUser: User, completion: ((Error?) -> Void)?) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text": message,
                    "fromId": currentUID,
                    "toId": toUser.uid,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_MESSAGES.document(currentUID).collection(toUser.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGES.document(toUser.uid).collection(currentUID).addDocument(data: data, completion: completion)
            COLLECTION_MESSAGES.document(currentUID).collection("recent-messages").document(toUser.uid).setData(data)
            COLLECTION_MESSAGES.document(toUser.uid).collection("recent-messages").document(currentUID).setData(data)
        }
    }
}
