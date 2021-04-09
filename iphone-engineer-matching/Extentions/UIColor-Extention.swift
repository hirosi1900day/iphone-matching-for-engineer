//
//  UIColor-Extention.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/04/07.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat ,blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
