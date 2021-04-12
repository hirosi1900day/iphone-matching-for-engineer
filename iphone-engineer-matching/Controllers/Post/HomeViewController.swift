//
//  HomeViewController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/03/31.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
   
    @IBOutlet weak var homeSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    //検索結果配列
    var searchResult = [PostData]()
    
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //デリゲート先を自分に設定する。
        tableView.delegate = self
        tableView.dataSource = self
        homeSearchBar.delegate = self
        
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        homeSearchBar.enablesReturnKeyAutomatically = false
        
        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                
                //取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                //検索結果配列にデータをコピーする。
                self.searchResult = self.postArray
                print("searchResult\(self.searchResult)")
                // TableViewの表示を更新する
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return postArray.count
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(searchResult[indexPath.row])
        
        // いいねボタンのイベントを作成する
        cell.likeButton.addTarget(self, action:#selector(handleLikeButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //詳細画面に飛ばす
        let DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailsViewController
        
        DetailsViewController.postData = searchResult[indexPath.row]
        navigationController?.pushViewController(DetailsViewController, animated: true)
//        self.present(DetailsViewController, animated: true, completion: nil)
    }
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        homeSearchBar.endEditing(true)
        
        //検索結果配列を空にする。
        searchResult.removeAll()
        
        if(homeSearchBar.text == "") {
            //検索文字列が空の場合はすべてを表示する。
            searchResult = postArray
        }else {
            print("配列\(postArray)")
            //検索文字列を含むデータを検索結果配列に追加する。
            for postData in postArray {
                let title: String? = postData.postTitle
                let qualification: String? = postData.qualification
                let genre: String? = postData.genre
                
                if title!.contains(homeSearchBar.text!) {
                    searchResult.append(postData)
                }else if qualification!.contains(homeSearchBar.text!) {
                    searchResult.append(postData)
                }else if genre!.contains(homeSearchBar.text!) {
                    searchResult.append(postData)
                }
            }
            print("配列中身\(searchResult)")
        }
        //テーブルを再読み込みする。
        tableView.reloadData()
    }
    
    @objc func handleLikeButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
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
