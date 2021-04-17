//
//  DetailsViewController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/03/31.
//

import UIKit
import Firebase
import FirebaseUI

class DetailsViewController: UIViewController {
    
    var postData: PostData!
   
    private var user: User?
    private var users = [User]()
    private var chatrooms = [ChatRoom]()
    private var selectedUser: User?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBAction func handleToChatView(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let partnerUid = postData.postUserUid else { return }
        let memebers = [uid, partnerUid]
        
        let docData = [
            "memebers": memebers,
            "latestMessageId": "",
            "createdAt": Timestamp()
        ] as [String : Any]
        
        if uid == partnerUid {
            return
        }
        self.CheckAndMoveChatRoom(uid: uid, partnerUid: partnerUid,docData: docData)
    }
    
            
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPostData(_postData: postData)
        navigationItem.title = "詳細ページ"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        userImage.layer.cornerRadius = 25
        fetchLoginUserInfo()
    }
    
    private func CheckAndMoveChatRoom(uid: String, partnerUid: String, docData: [String : Any]) {
        
        Firestore.firestore().collection("chatRooms").getDocuments() {(Snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in Snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dic = document.data()
                    let chatroom = ChatRoom(dic: dic)
                    chatroom.documentId = document.documentID
                    if chatroom.memebers.contains(uid) && chatroom.memebers.contains(partnerUid) {
                        
                        let ChatRoomViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
                        ChatRoomViewController.user = self.user
                        ChatRoomViewController.chatroom = chatroom
                        self.navigationController?.pushViewController(ChatRoomViewController, animated: true)
                        return
                    }
                }
                self.makeChatRoom(docData: docData)
            }
        }
        
        
    }
    
    private func makeChatRoom(docData: [String: Any]) {
       
        let chatRoomId = randomString(length: 20)
        Firestore.firestore().collection("chatRooms").document(chatRoomId).setData (docData) { (err) in
            if let err = err {
                print("ChatRoom情報の保存に失敗しました。\(err)")
                return
            }else{
                Firestore.firestore().collection("chatRooms").document(chatRoomId).getDocument { (Snapshot, err) in
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました。\(err)")
                        return
                    }
                    guard let dic = Snapshot?.data() else { return }
                    let chatroom = ChatRoom(dic: dic)
                    chatroom.documentId = Snapshot?.documentID
                    
                    let ChatRoomViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
                    ChatRoomViewController.user = self.user
                    ChatRoomViewController.chatroom = chatroom
                    self.navigationController?.pushViewController(ChatRoomViewController, animated: true)
                }
            }
        }
    }
    private func fetchLoginUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                return
            }
            
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            
            let user = User(dic: dic)
            self.user = user
        }
    }
    //ランダムな文字列を表示する
    private func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    // PostDataの内容をセルに表示
    func setPostData(_postData: PostData) {
        // 画像の表示
        if postData.postUserUid != nil{
            userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.postUserUid! + ".jpg")
            userImage.sd_setImage(with: imageRef)
        }
        
        //名前を表示する
        self.userName.text = "\(postData.name)"
        
        // タイトルの表示
        self.titleLabel.text = "\(postData.postTitle!)"
        
        // 募集内容の表示
        self.postContentLabel.text = "\(postData.postContent!)"
        
        // 応募資格の表示
        self.qualificationLabel.text = "\(postData.qualification!)"
        
        
        // ジャンルの表示
        self.genreLabel.text = "\(postData.genre!)"
    }
    
}
