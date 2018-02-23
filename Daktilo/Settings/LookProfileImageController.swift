//
//  LookProfileImageController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 25.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class LookProfileImageController: UIViewController {
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
        
    }()
    
    func setupProfileImage() {
        view.addSubview(profileImageView)
        profileImageView.anchor(topAnchor: nil, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    
    func fetchImage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let profileImage = User.init(dictionary: dictionary)
            print(profileImage.profileImageUrl)
            
                self.profileImageView.loadImage(urlString: profileImage.profileImageUrl)
            
            
        }) { (err) in
            print(err)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProfileImage()
        fetchImage()
    }
}
