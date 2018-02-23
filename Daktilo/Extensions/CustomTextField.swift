//
//  TextFieldRect.swift
//  Daktilo
//
//  Created by Burak Şentürk on 30.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 5)
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
   
    
}

class CustomTF: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
   
}

class CustomInputTF: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

