//
//  User.swift
//  Daktilo
//
//  Created by Burak Şentürk on 1.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import Foundation
struct User {
    let username : String
    let profileImageUrl : String
    init(dictionary : [String : Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["ProfileImageUrl"] as? String ?? ""
        
    
    }
}


