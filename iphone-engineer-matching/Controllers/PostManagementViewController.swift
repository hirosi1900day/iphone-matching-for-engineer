//
//  PostManagementViewController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/03/31.
//

import UIKit
import Firebase
import SVProgressHUD

class PostManagementViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    let dataList = [["起業","お仲間探し","趣味開発","その他"]]
    var postData: PostData!
    var data1: String?
    
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var postContentTextField: UITextField!
    @IBOutlet weak var qualificationTextField: UITextField!
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var genreLabel: UILabel!
   
    
    
    @IBAction func postUpdate(_ sender: Any) {
    
    print("アップデート前")
        if let postTitle = postTitleTextField.text, let qualification = qualificationTextField.text, let postContent = postContentTextField.text, let user = Auth.auth().currentUser {
            print("中にはいいて")
            //いずれかでも入力されていない時は何もしない
            if postTitle.isEmpty || qualification.isEmpty || postContent.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            //ジャンルに入力がない場合は元の文字列を入れる
           
            if  data1 == nil{
                self.data1 = postData.genre!
            }
            
            print("アップデート実行中")
            // 投稿データの保存場所を定義する
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            // HUDで投稿処理中の表示を開始
            SVProgressHUD.show()
            // FireStoreに投稿データを保存する
            let name = user.displayName
            let postDic = [
                "name": name!,
                "postUserUid": user.uid,
                "postTitle": postTitle,
                "qualification": qualification,
                "postContent": postContent,
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
    @IBAction func postUpdateCancel(_ sender: Any) {
        print("キャンセル")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPostData(_postData: postData)
        genrePicker.delegate = self
        genrePicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    // PostDataの内容をセルに表示
    func setPostData(_postData: PostData) {
        
        // タイトルの表示
        self.postTitleTextField.text = "\(postData.postTitle!)"
        
        // 募集内容の表示
        self.postContentTextField.text = "\(postData.postContent!)"
        
        // 応募資格の表示
        self.qualificationTextField.text = "\(postData.qualification!)"
        
        
        // ジャンルの表示
        self.genreLabel.text = "\(postData.genre!)"
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
