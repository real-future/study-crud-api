//
//  UIFontExtention.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/14.
//

import UIKit

extension UIFont {
    enum OpenSansType: String {
        case bold = "Bold"
        case regular = "Regular"
        
        
        var fullName: String {
            return "OpenSans-\(self.rawValue)"
        }
    }
    
    
    static func openSans(type: OpenSansType, size: CGFloat) -> UIFont {
        return UIFont(name: type.fullName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
