//
//  SignUpViewController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/04/17.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {

    
    
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var displayNameTextField: UITextField!
   
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            //アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            // HUDで処理中を表示
            SVProgressHUD.show()
            //アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    //エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            //プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        // HUDを消す
                        SVProgressHUD.dismiss()
                        
                        // 画面を閉じてタブ画面に戻る
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                self.createUserForFirebase(email: address, username: displayName)
                
            }
        }
    }
    
    @IBAction func moveToLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func createUserForFirebase(email: String,username: String) {
        let docData = [
            "email": email,
            "username": username,
            "createdAt": Timestamp(),
        ] as [String : Any]
        var uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("users").document(uid!).setData(docData) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                return
            }
        }
        
    }

}
