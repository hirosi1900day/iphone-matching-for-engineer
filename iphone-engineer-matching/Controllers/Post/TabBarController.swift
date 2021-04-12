//
//  TabBarController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/03/31.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            print("ログインしていない")
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
            print("ログイン遷移後")
        }
        // Do any additional setup after loading the view.
        print("ログイン遷移なし")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }
    
    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostViewController {
            // posrviewControllerはモーデル遷移にする
            let postViewController = storyboard!.instantiateViewController(withIdentifier: "PostView")
            present(postViewController, animated: true)
            print("true")
            return false
        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            print("false")
            return true
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
