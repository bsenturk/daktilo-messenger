//
//  UserSearchCell.swift
//  Daktilo
//
//  Created by Burak Şentürk on 12.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class UserSearchCell: UICollectionViewCell {
    
    var user : UserWithUid? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            addButton.addTarget(self, action: #selector(handleAddFriend), for: .touchUpInside)
            
            
            
        }
        
    }
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        return iv
    }()
    
    let addButton : UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus-button").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let usernameLabel : UILabel = {
       let label = UILabel()
        label.text = "ASDASDASD"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    let seperatorView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        return view
    }()
    
    private func setupCellItems() {
        addSubview(profileImageView)
        profileImageView.anchor(topAnchor: nil, leftAnchor: leftAnchor, bottomAnchor: nil, rightAnchor: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 25
        
        addSubview(addButton)
        addButton.anchor(topAnchor: nil, leftAnchor: nil, bottomAnchor: nil, rightAnchor: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: -8, width: 70, height: 70)
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(topAnchor: topAnchor, leftAnchor: profileImageView.rightAnchor, bottomAnchor: bottomAnchor, rightAnchor: addButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(seperatorView)
        seperatorView.anchor(topAnchor: nil, leftAnchor: leftAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    @objc func handleAddFriend() {
       
        guard let addUserUsername = user?.username else { return }
        guard let uidOfAddedUser = user?.uid else { return }
        let alert = UIAlertController(title: "Friend Request", message: "Do you want add \(addUserUsername)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let values = ["\(uid)" : 0]

            Database.database().reference().child("Friend Requests").child(uidOfAddedUser).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to add friend",err)
                }
                print("Sucessfully send friend request",ref)
            })

        }))

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCellItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
