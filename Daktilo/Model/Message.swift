//
//  Message.swift
//  Daktilo
//
//  Created by Burak Şentürk on 18.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
struct Message {
    let fromId : String
    let message : String
    let timeStamp : NSNumber
    let toId : String
    let imageUrl : String
    let imageWidth : NSNumber
    let imageHeight : NSNumber
    let videoUrl : String
    init(dictionary : [String : Any]) {
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.message = dictionary["message"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? NSNumber ?? 0
        self.toId = dictionary["toId"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.imageWidth = dictionary["imageWidth"] as?  NSNumber ?? 0
        self.imageHeight = dictionary["imageHeight"] as? NSNumber ?? 0
        self.videoUrl = dictionary["videoUrl"] as? String ?? ""
        
    }
    
    func chatPartnerId() -> String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
}
