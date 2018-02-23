//
//  ChangePasswordController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 28.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class ChangePasswordController: UIViewController {
    
    let passwordTextField : CustomTF = {
       let tf = CustomTF()
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "padlock-2")
        let leftView = UIView()
        leftView.addSubview(iv)
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        iv.frame = CGRect(x: 5, y: 0, width: 25, height: 25)
        tf.placeholder = "New Password"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.isSecureTextEntry = true
        tf.leftViewMode = .always
        tf.leftView = leftView
        tf.addTarget(self, action: #selector(setupInputChanges), for: .editingChanged)
        
        return tf
    }()
    let passwordAgainTextField : CustomTF = {
        let tf = CustomTF()
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "padlock-2")
        let leftView = UIView()
        leftView.addSubview(iv)
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        iv.frame = CGRect(x: 5, y: 0, width: 25, height: 25)
        tf.placeholder = "New Password Again"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.isSecureTextEntry = true
        tf.leftViewMode = .always
        tf.leftView = leftView
         tf.addTarget(self, action: #selector(setupInputChanges), for: .editingChanged)
        return tf
        
    }()
    
    let changeButton : UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Change", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        button.addTarget(self, action: #selector(handleChangePass), for: .touchUpInside)
        return button
    }()
    
    let successfullView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        view.isHidden = true
       return view
    }()
    
    let checkImageView : UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "check"))
        iv.contentMode = .scaleAspectFill
        iv.isHidden = true
        return iv
    }()
    
    private func setupInputTextFields() {
        view.addSubview(passwordTextField)
        view.addSubview(passwordAgainTextField)
        
        passwordTextField.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 50)
        passwordAgainTextField.anchor(topAnchor: passwordTextField.bottomAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 50)
        
    }
    private func setupButton() {
        view.addSubview(changeButton)
        
        changeButton.anchor(topAnchor: passwordAgainTextField.bottomAnchor, leftAnchor: passwordAgainTextField.leftAnchor, bottomAnchor: nil, rightAnchor: passwordAgainTextField.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
    }
    
    @objc func setupInputChanges() {
        let isValid = passwordTextField.text?.count ?? 0 > 0 && passwordAgainTextField.text?.count ?? 0 > 0
        
        if isValid {
            changeButton.isEnabled = true
            changeButton.backgroundColor = UIColor.rgb(red: 90, green: 240, blue: 0)
        }
        else {
            changeButton.isEnabled = false
            changeButton.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        }
    }
    
    @objc func handleChangePass() {
        if passwordTextField.text != passwordAgainTextField.text {
            let alert = UIAlertController(title: "Error", message: "Your password does not equal to each other", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
          guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let passwordText = passwordTextField.text else { return }
           
         let user = Auth.auth().currentUser
            user?.updatePassword(to: passwordText, completion: { (err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                else {
                    print("Successfully update password for Auth")
                    self.present(LoginController(), animated: true, completion: nil)
                    
                }
            })
            if let email = user?.email {
                let credential = EmailAuthProvider.credential(withEmail: email, password: passwordText)
                user?.reauthenticate(with: credential, completion: { (err) in
                    if let err = err {
                        print(err.localizedDescription)
                    }
                    else {
                        print("Successfully re auth")
                    }
                })
            }
            
            
            
            
            let values = ["password" : passwordText]
            Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to update password :",err)
                }
                self.successfullView.isHidden = false
                self.checkImageView.isHidden = false
                print("Successfully to update password")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        }
        
    }
    
    private func setupSuccessfullView() {
        view.addSubview(successfullView)
        successfullView.addSubview(checkImageView)
        successfullView.anchor(topAnchor: nil, leftAnchor: nil, bottomAnchor: nil, rightAnchor: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        successfullView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        successfullView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Image View
        checkImageView.anchor(topAnchor: successfullView.topAnchor, leftAnchor: successfullView.leftAnchor, bottomAnchor: successfullView.bottomAnchor, rightAnchor: successfullView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 0, green: 175, blue: 169)
        navigationItem.title = "Change Password"
        //Called Functions
        setupInputTextFields()
        setupButton()
        setupSuccessfullView()
    }
}
