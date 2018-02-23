//
//  Extensions.swift
//  Daktilo
//
//  Created by Burak Şentürk on 22.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green : CGFloat , blue : CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    
}



extension UIView {
    func anchor(topAnchor : NSLayoutYAxisAnchor? , leftAnchor : NSLayoutXAxisAnchor?, bottomAnchor : NSLayoutYAxisAnchor?, rightAnchor : NSLayoutXAxisAnchor? , paddingTop : CGFloat , paddingLeft: CGFloat , paddingBottom : CGFloat , paddingRight : CGFloat, width : CGFloat , height : CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
        }
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: paddingLeft).isActive = true
        }
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: paddingBottom).isActive = true
        }
        if let rightAnchor = rightAnchor {
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: paddingRight).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        
        
    }
    
}
