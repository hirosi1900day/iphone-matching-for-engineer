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
    private var users = [User]()
    private var selectedUser: User?
    
    @IBOutlet weak var userImage: UIImageView!
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
        
        Firestore.firestore().collection("chatRooms").addDocument(data: docData) { (err) in
            if let err = err {
                print("ChatRoom情報の保存に失敗しました。\(err)")
                return
            }
//
////            self.dismiss(animated: true, completion: nil)
            print("ChatRoom情報の保存に成功しました。")

        }
        
//        let ChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatView") as! ChatViewController
//        self.present(ChatViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func handleBackButton(_ sender: Any) {
        //戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPostData(_postData: postData)
        // Do any additional setup after loading the view.
    }
    // PostDataの内容をセルに表示
    func setPostData(_postData: PostData) {
        // 画像の表示
        if postData.postUserUid != nil{
            userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.postUserUid! + ".jpg")
            userImage.sd_setImage(with: imageRef)
        }
        // タイトルの表示
        self.titleLabel.text = "\(postData.postTitle!)"
        
        // 募集内容の表示
        self.postContentLabel.text = "\(postData.postContent!)"
        
        // 応募資格の表示
        self.qualificationLabel.text = "\(postData.qualification!)"
        
        
        // ジャンルの表示
        self.genreLabel.text = "\(postData.genre!)"
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
