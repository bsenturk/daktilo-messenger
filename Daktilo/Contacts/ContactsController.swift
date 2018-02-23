//
//  ContactsController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 27.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var users = [UserWithUid]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "addUser").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddUser))
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        fetchFriends()
        refreshControl()
        
        
    }
    
     func refreshControl() {
        let refreshControl = UIRefreshControl()
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
    
    @objc func handleRefresh() {
        users.removeAll()
        fetchFriends()
        collectionView?.refreshControl?.endRefreshing()
        
    }
    
    
    private func fetchFriends() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("Friends").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach({ (key,value) in
                
            Database.database().reference().child("Users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let friendsValue = snapshot.value as? [String : Any] else { return }
                let users = UserWithUid.init(uid: key, dictionary: friendsValue)
                self.users.append(users)
//                self.users.sort(by: { (u1, u2) -> Bool in
//                    return u1.username.compare(u2.username) == .orderedAscending
//                })
                self.timer?.invalidate()
              self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
                
               
                }, withCancel: { (err) in
                    print("Failed to fetch users",err)
                })
                
                
            })
            
        }) { (err) in
            print("Failed to fetch friends",err)
        }
    }
    var timer : Timer?
    @objc func handleReload() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    @objc func handleAddUser() {
        let layout = UICollectionViewFlowLayout()
        let addUserController = AddUserController(collectionViewLayout: layout)
        addUserController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addUserController, animated: true)
    }
    
    func shotChatLogController(user: UserWithUid){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ContactsCell
        cell.user = users[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        shotChatLogController(user: user)
        
    }
    
    
    
    
}
