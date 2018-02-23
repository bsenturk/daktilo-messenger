//
//  UserWithUid.swift
//  Daktilo
//
//  Created by Burak Şentürk on 12.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import Foundation
struct UserWithUid {
    let uid : String
    let username : String
    let profileImageUrl : String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["ProfileImageUrl"] as? String ?? ""
    }
    
   
}
