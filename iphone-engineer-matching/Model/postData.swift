//
//  postData.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/04/01.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String
    var postUserUid: String? = ""
    var postTitle: String?
    var qualification: String?
    var zoomUrl: String?
    var postContent: String?
    var genre: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String ?? ""
        
        self.postUserUid = postDic["postUserUid"] as? String
        
        self.postTitle = postDic["postTitle"] as? String
        
        self.qualification = postDic["qualification"] as? String
        
        self.zoomUrl = postDic["zoomUrl"] as? String
        
        self.postContent = postDic["postContent"] as? String
        
        self.genre = postDic["genre"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
    }
}
