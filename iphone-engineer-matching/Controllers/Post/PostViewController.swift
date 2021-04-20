//
//  PostViewController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/03/31.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let dataList = [["起業","お仲間探し","趣味開発","その他"]]
    var data1: String?
    
    @IBOutlet weak var postTitle: UITextField!
    
    @IBOutlet weak var qualification: UITextView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var genre: UIPickerView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBAction func handleCreatePostButton(_ sender: Any) {
        if let postTitle = postTitle.text, let qualification = qualification.text, let postContent = postContent.text, let genre = data1, let user = Auth.auth().currentUser {
            
            //いずれかでも入力されていない時は何もしない
            if postTitle.isEmpty || qualification.isEmpty || postContent.isEmpty || genre.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }

            // 投稿データの保存場所を定義する
            let postRef = Firestore.firestore().collection(Const.PostPath).document()
            // HUDで投稿処理中の表示を開始
            SVProgressHUD.show()
            // FireStoreに投稿データを保存する
            let name = user.displayName
            let postDic = [
                "name": name!,
                "postUserUid": user.uid,
                "postTitle": self.postTitle.text!,
                "qualification": self.qualification.text!,
                "postContent": self.postContent.text!,
                "genre": data1!,
                "date": FieldValue.serverTimestamp(),
            ] as [String : Any]
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //ビューを作成する。
        genre.delegate = self
        genre.dataSource = self
        genre.selectRow(0, inComponent: 0, animated: true)
        // Do any additional setup after loading the view.
    }
    
    
    //コンポーネントの個数を返すメソッド
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    
    //コンポーネントに含まれるデータの個数を返すメソッド
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList[component].count
    }
    
    
    //データを返すメソッド
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[component][row]
    }
    
    
    //データ選択時の呼び出しメソッド
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //コンポーネントごとに現在選択されているデータを取得する。
        data1 = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)
        
        genreLabel.text = "選択　\(data1!)"
    }
    

}
