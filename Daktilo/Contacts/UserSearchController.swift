//
//  AddUserController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 2.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class AddUserController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let searchBar : UISearchBar = {
       let sb = UISearchBar()
        sb.placeholder = "Search"
        
        return sb
    }()
    
    //Search bar function
    private func setupSearchBar() {
        view.addSubview(searchBar)
        
        //Constraints
        searchBar.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredUser = users
//        }
      //  else {
            self.filteredUser = self.users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
       // }
        self.collectionView?.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    var users = [UserWithUid]()
    var filteredUser = [UserWithUid]()
    private func fetchUsers() {
        print("Fetching Users")
        Database.database().reference().child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String : Any] else { return }
            userDictionary.forEach({ (key,value) in
                if key == Auth.auth().currentUser?.uid {
                        print("Found myself")
                        return
                }
                
                guard let dictionary = value as? [String : Any] else { return }
                let user = UserWithUid.init(uid: key, dictionary: dictionary)
                print(user.uid,user.username)
                self.users.append(user)
                self.users.sort(by: { (u1, u2) -> Bool in
                    return u1.username.compare(u2.username) == .orderedAscending
                })
                self.collectionView?.reloadData()
                
            
            })
            
        }) { (err) in
            print("Failed to fetch users",err)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUser.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
//        cell.addButton.addTarget(self, action: #selector(handleAddFriend), for: .touchUpInside)
        cell.user = filteredUser[indexPath.item]
        
        
       
        
        
        
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let a = filteredUser[indexPath.item]
//        print(a.uid,a.username)
//
//        let alert = UIAlertController(title: "Friend Request", message: "Do you want add \(a.username)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            let values = ["\(uid)" : 0]
//
//            Database.database().reference().child("Friend Requests").child(a.uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
//                if let err = err {
//                    print("Failed to add friend",err)
//                }
//                print("Sucessfully send friend request",ref)
//            })
//
//        }))
//
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
//
//    }
//
//
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 55, left: 0, bottom: 0, right: 0)
    }
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "Search"
        searchBar.delegate = self
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchUsers()
       
        
        
        //Called function
        setupSearchBar()
    }
}
