//
//  FriendRequestsCell.swift
//  Daktilo
//
//  Created by Burak Şentürk on 12.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class FriendRequestsCell: UICollectionViewCell {
    
    
    
    var userRequests : UserWithUid? {
        didSet{
            guard let profileImageUrl = userRequests?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl )
            usernameLabel.text = userRequests?.username
             acceptButton.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
            rejectButton.addTarget(self, action: #selector(handleReject), for: .touchUpInside)

            
            
        }
        
       
        
    }
    
   
    
    @objc func handleAccept()  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uidOfAdded = userRequests?.uid else { return }
        let values = ["\(uidOfAdded)" : 1]
        let valuesOfAdded = ["\(uid)" : 1]
        Database.database().reference().child("Friends").child(uid).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to update friend",err)
            }
            print("Successfully to update friend")
                        
        Database.database().reference().child("Friends").child(uidOfAdded).updateChildValues(valuesOfAdded, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to update friend",err)
                }
                print("Successfully to update friend")
            
            })
            
            
            Database.database().reference().child("Friend Requests").child(uid).child(uidOfAdded).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to remove value",err)
                }
                print("Successfully remove the value")
            })
           
        }
    
    }
    
    @objc func handleReject() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uidOfAdded = userRequests?.uid else { return }
        
        Database.database().reference().child("Friend Requests").child(uid).child(uidOfAdded).removeValue(completionBlock: { (err, ref) in
            if let err = err {
                print("Failed to remove value",err)
            }
            print("Successfully remove the value")
        })
    }
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        
        return iv
    }()
    
    let usernameLabel : UILabel = {
       let label = UILabel()
        label.text = "adsasdads"
        label.textAlignment = .center
        return label
    }()
    
    let acceptButton : UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "accept").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let rejectButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "reject").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
        
    }()
    
    let seperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        return view
    }()
    
    private func setupCellFields() {
        addSubview(profileImageView)
        profileImageView.anchor(topAnchor: nil, leftAnchor: leftAnchor, bottomAnchor: nil, rightAnchor: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 25
        
        
        addSubview(rejectButton)
        
        rejectButton.anchor(topAnchor: nil, leftAnchor: nil, bottomAnchor: nil, rightAnchor: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: -4, width: 40, height: 40)
        rejectButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(acceptButton)
        
        acceptButton.anchor(topAnchor: nil, leftAnchor: nil, bottomAnchor: nil, rightAnchor: rejectButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: -4, width: 40, height: 40)
        acceptButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(topAnchor: topAnchor, leftAnchor: profileImageView.rightAnchor, bottomAnchor: bottomAnchor, rightAnchor: acceptButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(seperatorView)
        seperatorView.anchor(topAnchor: nil, leftAnchor: leftAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCellFields()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
