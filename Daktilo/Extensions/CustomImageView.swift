//
//  CustomImageView.swift
//  Daktilo
//
//  Created by Burak Şentürk on 4.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
class CustomImageView: UIImageView {
    
   
    func loadImage(urlString : String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch image :",err)
            }
            guard let imageData = data else { return }
            guard let image =  UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }.resume()
        
        
        
    }
    
    
}
