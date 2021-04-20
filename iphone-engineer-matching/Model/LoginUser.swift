//
//  LoginUser.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/04/20.
//

import RealmSwift

class LoginUser: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    @objc dynamic var accessUser: String = ""
    
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

