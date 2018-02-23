//
//  SignUpController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 23.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class SignUpController: UIViewController {
    
    let inputContainerView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    let usernameTextField : CustomTextField = {
       let tf = CustomTextField()
        tf.placeholder = "Username"
        tf.leftViewMode = .always
        tf.leftView = UIImageView(image: #imageLiteral(resourceName: "user"))
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return tf
    }()
    let emailTextField : CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "E-mail"
        tf.leftViewMode = .always
        tf.leftView = UIImageView(image: #imageLiteral(resourceName: "icons8-Message-50"))
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    let passwordTextField : CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Password"
        tf.leftViewMode = .always
        tf.leftView = UIImageView(image: #imageLiteral(resourceName: "icons8-Lock-50"))
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    let passwordAgainTextField : CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Password Again"
        tf.leftViewMode = .always
        tf.leftView = UIImageView(image: #imageLiteral(resourceName: "icons8-Lock-50"))
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleInputChange() {
        let isValid = usernameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && passwordAgainTextField.text?.count ?? 0 > 0
        
        if isValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 90, green: 240, blue: 0)
        }
        else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        }
        
    }
    
    let usernameSeperatorView : UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
        
    }()
    let emailSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
        
    }()
    let passwordSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
        
    }()
    
    
    let alreadyHaveAccountButton : UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Already have an account? Sign In!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func backToLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Daktilo"
        label.font = UIFont(name: "Manksa", size: 90)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    //View's Functions
    
    private func setupInputContainerView() {
        view.addSubview(inputContainerView)
        
        //Container View Constraints
        inputContainerView.anchor(topAnchor: nil, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 200)
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    private func setupSignUpButton() {
        view.addSubview(signUpButton)
        
        //Sign Up Button Constraints
        signUpButton.anchor(topAnchor: inputContainerView.bottomAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    private func setupTextFields() {
        inputContainerView.addSubview(usernameTextField)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(passwordTextField)
        inputContainerView.addSubview(passwordAgainTextField)
        inputContainerView.addSubview(usernameSeperatorView)
        inputContainerView.addSubview(emailSeperatorView)
        inputContainerView.addSubview(passwordSeperatorView)
        
        //Username Text Fields Constraints
        usernameTextField.anchor(topAnchor: inputContainerView.topAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        //Email Text Fields Constraints
        emailTextField.anchor(topAnchor: usernameTextField.bottomAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        //Password Text Fields Constraints
        passwordTextField.anchor(topAnchor: emailTextField.bottomAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        passwordAgainTextField.anchor(topAnchor: passwordTextField.bottomAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        //Seperator View Constraints
        usernameSeperatorView.anchor(topAnchor: usernameTextField.bottomAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)

        emailSeperatorView.anchor(topAnchor: emailTextField.bottomAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)

        passwordSeperatorView.anchor(topAnchor: passwordTextField.bottomAnchor, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    private func setupAlreadyHaveAccountButton() {
        view.addSubview(alreadyHaveAccountButton)
        
        //Contraints
        alreadyHaveAccountButton.anchor(topAnchor: nil, leftAnchor: nil, bottomAnchor: view.bottomAnchor, rightAnchor: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -4, paddingRight: 0, width: 235, height: 50)
        alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        
        nameLabel.anchor(topAnchor: view.topAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 48, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 100)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
  
    //Signing Up users.
    @objc func handleSignUp() {

        createUser()
        
    }
    
    func createUser() {
        
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: passwordText) { (user, err) in
            
            guard let uid = user?.uid else { return }
            if let err = err {
                print(err)
                return
            }
            
            print("Successfully create user :", uid)
            Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                if let err = err {
                    print("Failed to send email verification:",err)
                }
                print("Successfully to send email verification:")
            })
            
            let values = ["username" : username , "email" : email , "password" : passwordText, "ProfileImageUrl" : ""]
            
            Database.database().reference().child("Users").child(uid).updateChildValues(values) { (err, ref) in
                
                if let err = err {
                    print("Failed save user to database",err)
                }
                print("Successfully save user to database")
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    func dismisskeyboard() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            view.addGestureRecognizer(tap)
    }
    
    @objc func handleDismiss() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 0, green: 175, blue: 169)
        dismisskeyboard()
        //Called Function
        setupInputContainerView()
        setupSignUpButton()
        setupTextFields()
        setupAlreadyHaveAccountButton()
        setupNameLabel()
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
