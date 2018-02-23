//
//  SettingsController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 27.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user : User?
    
    //View elements
    let headerContainerView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var profileImageView : UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "user-3"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSeeProfileImage)))
       
       return iv
    }()
   
    
    let changeProfileImageButton : UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Change", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileImage), for: .touchUpInside)
        
        return button
    }()
    let usernameLabel : UILabel = {
       let label = UILabel()
        //label.text = "HELLO FROM OTHER SIDE"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let changePasswordButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Change Password", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.setImage(#imageLiteral(resourceName: "icons8-Password-54").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 130)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -110, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        
        return button
    }()
    
    let friendRequestButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Friend Request", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.setImage(#imageLiteral(resourceName: "friendRequest").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 150)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -130, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleFriendRequest), for: .touchUpInside)
        
        return button
        
        
    }()
    
    let exitButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.setImage(#imageLiteral(resourceName: "icons8-Door Opened-54").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 220)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let deleteAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Remove Account", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.setImage(#imageLiteral(resourceName: "icons8-Cancel-54").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 140)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -120, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
        return button
    }()
    
    //View's Function
    private func setupHeaderContainerView() {
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(profileImageView)
        headerContainerView.addSubview(changeProfileImageButton)
        headerContainerView.addSubview(usernameLabel)
        
        //Container view constraints
        headerContainerView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 110)
        
        //Profile Image View Constraints
        profileImageView.anchor(topAnchor: headerContainerView.topAnchor, leftAnchor: headerContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        profileImageView.layer.cornerRadius = 70 / 2
        
        //Change Button Constraints
        changeProfileImageButton.anchor(topAnchor: profileImageView.bottomAnchor, leftAnchor: headerContainerView.leftAnchor, bottomAnchor: headerContainerView.bottomAnchor, rightAnchor: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //Username Label Constraints
        usernameLabel.anchor(topAnchor: headerContainerView.topAnchor, leftAnchor: profileImageView.rightAnchor, bottomAnchor: nil, rightAnchor: headerContainerView.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
  
        
        
        
    }
    
    private func setupButtons() {
        view.addSubview(changePasswordButton)
        view.addSubview(friendRequestButton)
        view.addSubview(exitButton)
        view.addSubview(deleteAccountButton)
        
        //Change Password Button Constraints
        changePasswordButton.anchor(topAnchor: headerContainerView.bottomAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        friendRequestButton.anchor(topAnchor: changePasswordButton.bottomAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        //Exit Button Constraints
        exitButton.anchor(topAnchor: friendRequestButton.bottomAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        deleteAccountButton.anchor(topAnchor: exitButton.bottomAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    //Change Password
    @objc func handleChangePassword() {
        let changePasswordController = ChangePasswordController()
        changePasswordController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(changePasswordController, animated: true)
        
        
    }
    
    //Friend Request
    @objc func handleFriendRequest() {
        let layout = UICollectionViewFlowLayout()
        let friendsRequestsController = FriendRequestsController(collectionViewLayout: layout)
        friendsRequestsController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(friendsRequestsController, animated: true)
        
    }
    
    //Logout
    @objc func handleLogout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action : UIAlertAction!) in
            
            do{
                try Auth.auth().signOut()
                self.present(LoginController(), animated: true, completion: nil)
                
            }catch let err {
                print(err)
            }
        }))
      alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func handleDeleteAccount() {
         let alert = UIAlertController(title: "Remove Account", message: "Are you sure want to remove your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action : UIAlertAction!) in
            
            guard let uid = Auth.auth().currentUser?.uid else { return  }
            Auth.auth().currentUser?.delete(completion: { (err) in
                if let err = err {
                    print("Failed to delete user:",err)
                }
                print("Successfully delete user")
            })
            let ref = Database.database().reference().child("Users").child(uid)
            ref.removeValue { (err, ref) in
                if let err = err {
                    print("Failed to remove users data from database :",err)
                }
                print("Successfully to remove users data from db")
                self.present(LoginController(), animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
       
        
    }
    
    private func fetchUsername() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ref = Database.database().reference().child("Users").child(uid)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String : Any] else { return }
           let user = User.init(dictionary: dictionary)
            self.usernameLabel.text = user.username
        }) { (err) in

            print("Failed to fetch username :",err)
        }
        
    }
    
    @objc func handleSeeProfileImage() {
        let lookProfileImageController = LookProfileImageController()
        lookProfileImageController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lookProfileImageController, animated: true)
        
    }
    
    @objc func handleChangeProfileImage() {
        let imagePicker = UIImagePickerController()
        self.present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }
    
    private func uploadProfileImage() {
        guard let image = profileImageView.image else { return }
        guard let uid = Auth.auth().currentUser?.uid else {return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        let fileName = NSUUID().uuidString
        Storage.storage().reference().child("Profile_Images").child(uid).child(fileName).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Failed to upload image:",err)
                
            }
            print("Successfully to upload image:",metadata ?? "")
            
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
           
            let value = ["ProfileImageUrl" : profileImageUrl]
            let ref = Database.database().reference().child("Users").child(uid)
            ref.updateChildValues(value, withCompletionBlock: { (err,ref) in
                if let err = err {
                    print("Failed to upload profile image in database:",err)
                }
                print("Successfully to upload profile image in database")
            })
        
        }
      
        
    }
    
    private func fetchProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let profileImage = User.init(dictionary: dictionary)
            
            print(profileImage.profileImageUrl)
            guard let url = URL(string: profileImage.profileImageUrl) else { return }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
                if let err = err {
                    print(err)
                }
                guard let image = UIImage(data : data!) else { return }
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }).resume()
            
            
        }) { (err) in
            print("Failed to fetch profile image:",err)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
           

        }
        else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = editedImage.withRenderingMode(.alwaysOriginal)
         
        }
   
        dismiss(animated: true, completion: nil)
        uploadProfileImage()

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        
        //Called Function
        setupHeaderContainerView()
        setupButtons()
        fetchUsername()
        fetchProfileImage()
        
        
    }
    
    
}
