//
//  ViewController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 22.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    //View elements
    let containerView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    //(red: 235, green: 95, blue: 66)
    //Login Button
    let loginButton : UIButton = {
       let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    let forgotPasswordButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 59, green: 89, blue: 152)
        button.setTitle("Forgot Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    //Email Text Field
    let emailTextField : CustomTextField = {
       let tf = CustomTextField()
       tf.placeholder = "E-Mail"
        tf.leftView = UIImageView(image: #imageLiteral(resourceName: "icons8-Message-50"))
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return tf
    }()
   //Password text Field
    let passwordTextField : CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Password"
        tf.leftView = UIImageView(image: #imageLiteral(resourceName: "icons8-Lock-50"))
        tf.leftViewMode = .always
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    //Seperator View
    let seperatorView : UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let nameLabel : UILabel = {
    let label = UILabel()
        label.text = "Daktilo"
        label.font = UIFont(name: "Manksa" , size: 90)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Don't have an account? Sign Up!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handlePresentSignUp), for: .touchUpInside)
        return button
    }()
    
     @objc func handlePresentSignUp() {
        let signUpController = SignUpController()
        present(signUpController, animated: true, completion: nil)
        }
    
    
    //Container View Function
    private func setupContainerView() {
        view.addSubview(containerView)
        
        //Container View Constraints
        containerView.anchor(topAnchor: nil, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: -14, width: 0, height: 120)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    //Login and Facebook Button Function
    private func setupLoginButtons() {
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        
        //Login Button Constraints
        loginButton.anchor(topAnchor: containerView.bottomAnchor, leftAnchor: containerView.leftAnchor, bottomAnchor: nil, rightAnchor: containerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
        //Facebook Button Constraints
        forgotPasswordButton.anchor(topAnchor: loginButton.bottomAnchor, leftAnchor: loginButton.leftAnchor, bottomAnchor: nil, rightAnchor: loginButton.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    //Email and Password Text Field Function
    private func setupEmailPasswordTextField() {
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(seperatorView)
        
        //Email Text Field Constraints
        emailTextField.anchor(topAnchor: containerView.topAnchor, leftAnchor: containerView.leftAnchor, bottomAnchor: nil, rightAnchor: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: -8, width: 0, height: 60)
        //Password Text Field Constraints
        passwordTextField.anchor(topAnchor: emailTextField.bottomAnchor, leftAnchor: containerView.leftAnchor, bottomAnchor: nil, rightAnchor: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: -8, width: 0, height: 60)
        
        //Seperator View
        seperatorView.anchor(topAnchor: emailTextField.bottomAnchor, leftAnchor: containerView.leftAnchor, bottomAnchor: nil, rightAnchor: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    //Text Input Change
    @objc func handleTextChange() {
        let isValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 90, green: 240, blue: 0)
        }
        else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        }
    }
   
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        
      nameLabel.anchor(topAnchor: view.topAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 48, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 100)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func setupSignUpButton() {
        view.addSubview(signUpButton)
        
        //Sign Up Button Constraints
        signUpButton.anchor(topAnchor: nil, leftAnchor: nil, bottomAnchor: view.bottomAnchor, rightAnchor: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -4, paddingRight: 0, width: 223, height: 50)
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: passwordText) { (user, err) in
            
            if Auth.auth().currentUser?.isEmailVerified == false {
                let alert = UIAlertController(title: "Error", message: "Your email has not been verified", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
            
            if let err = err {
                print("Failed to user login",err)
                let alert = UIAlertController(title: "Error", message: "Your email or password wrong!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            print("Successfully user login")
            let mainTabBarController = MainTabBarController()
            self.present(mainTabBarController, animated: true, completion: nil)
        }
        }
        
    }
    
    func hideKeyboard() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleDismissKeyboard() {
        view.endEditing(true)
    }
   
    @objc func handleForgotPassword() {
        let forgetPasswordController = ForgetPasswordController()
        let navController = UINavigationController(rootViewController: forgetPasswordController)
        present(navController, animated: true, completion: nil)
    
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 0, green: 175, blue: 169)
        
        
        hideKeyboard()
       
        
        //Called Function
        setupContainerView()
        setupLoginButtons()
        setupEmailPasswordTextField()
        setupNameLabel()
        setupSignUpButton()
    
    
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

