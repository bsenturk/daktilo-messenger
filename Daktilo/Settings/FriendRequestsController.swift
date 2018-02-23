//
//  FriendRequestsController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 12.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class FriendRequestsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.register(FriendRequestsCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.title = "Friend Requests"
        fetchRequests()
       
    }
    
    var friendRequests = [UserWithUid]()

     func fetchRequests() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("Friend Requests").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            dictionary.forEach({ (key,value) in
                
                Database.database().reference().child("Users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let requestsDictionary = snapshot.value as? [String : Any] else { return }
                    let users = UserWithUid.init(uid: key, dictionary: requestsDictionary)
                    
                    print(users)
                    self.friendRequests.append(users)
                    DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    }
                    
                    
                    
                }, withCancel: { (err) in
                    print("Failed to fetch users",err)
                })
                
                
            })
            
            
        }) { (err) in
            print("Failed to fetch requests",err)
        }
        
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendRequestsCell
        cell.userRequests = friendRequests[indexPath.item]
      
        
        return cell
    }
    
    
    

   

}
