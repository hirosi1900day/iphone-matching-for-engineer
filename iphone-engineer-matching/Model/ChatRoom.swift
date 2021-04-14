//
//  ChatRoom.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/04/11.
//

import Foundation
import Firebase

class ChatRoom {
    
    let latestMessageId: String
    let memebers: [String]
    let createdAt: Timestamp
    var partnerUser: User?
    var documentId: String?
    
    var latestMessage: Message?
    init(dic: [String: Any]) {
        
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.memebers = dic["memebers"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
