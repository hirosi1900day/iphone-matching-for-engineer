//
//  LoginViewController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/03/31.
//

import UIKit
import Firebase
import SVProgressHUD
import RealmSwift

class LoginViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            //アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                return
            }
            // HUDで処理中を表示
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                // HUDを消す
                SVProgressHUD.dismiss()
                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func moveToSignUp(_ sender: Any) {
        let SignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as! SignUpViewController
        present(SignUpViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil {
            self.dismiss(animated: true, completion: nil)
        }
        let access = Access()
        let allAccess = realm.objects(Access.self)
        if allAccess.count == 0 {
            access.id = 1
            try! self.realm.write {
                self.realm.add(access)
            }
            guard let StartViewController = self.storyboard?.instantiateViewController(withIdentifier: "Start") else { return }
            self.present(StartViewController, animated: true, completion: nil)
            print("text")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
