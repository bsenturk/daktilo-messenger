//
//  ContactsCell.swift
//  Daktilo
//
//  Created by Burak Şentürk on 4.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
class ContactsCell: UICollectionViewCell {
    
    var user : UserWithUid? {
        didSet{
            usernameLabel.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
        }
        
    }
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "bsenturk34"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let seperatorView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        
        profileImageView.anchor(topAnchor: nil, leftAnchor: leftAnchor, bottomAnchor: nil, rightAnchor: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        profileImageView.layer.cornerRadius = 25
        
        addSubview(usernameLabel)
        
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.anchor(topAnchor: topAnchor, leftAnchor: profileImageView.rightAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(seperatorView)
        seperatorView.anchor(topAnchor: nil, leftAnchor: usernameLabel.leftAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
