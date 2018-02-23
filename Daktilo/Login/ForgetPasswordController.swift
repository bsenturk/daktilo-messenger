//
//  ForgetPasswordController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 5.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class ForgetPasswordController: UIViewController {
    
    
    
    let emailTextFiled : CustomTF = {
       let tf = CustomTF()
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-Email-40"))
        let leftView = UIView()
        leftView.addSubview(iv)
        leftView.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        iv.frame = CGRect(x: 5, y: 0, width: 25, height: 25)
        tf.placeholder = "E-mail"
        tf.backgroundColor = .white
        tf.leftViewMode = .always
        tf.leftView = leftView
        tf.layer.cornerRadius = 5
        tf.addTarget(self, action: #selector(inputChange), for: .editingChanged)
        return tf
    }()
    
    let sendButton : UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendPassword), for: .touchUpInside)
        return button
    }()
    
    private func setupTextFieldAndButton() {
        view.addSubview(emailTextFiled)
        
        emailTextFiled.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 50)
        
        view.addSubview(sendButton)
        
        sendButton.anchor(topAnchor: emailTextFiled.bottomAnchor, leftAnchor: emailTextFiled.leftAnchor, bottomAnchor: nil, rightAnchor: emailTextFiled.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
       
        
    }
    
    @objc func inputChange() {
        let isValid = emailTextFiled.text?.count ?? 0 > 0
        if isValid {
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor.rgb(red: 90, green: 240, blue: 0)
        }
        else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor.rgb(red: 90, green: 220, blue: 0)
        }
        
    }
    
    @objc func sendPassword() {
        guard let email = emailTextFiled.text else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            if let err = err {
                print("Failed to send email",err)
            }
            print("Successfully to send reset password")
            let label = UILabel()
            label.text = "Successfully to send reset password code"
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = UIColor(white: 0, alpha: 0.3)
            label.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            label.center = self.view.center
            self.view.addSubview(label)
            
            label.layer.transform = CATransform3DMakeScale(0, 0, 0)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                label.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
            }, completion: { (completion) in
                
                UIView.animate(withDuration: 1.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        label.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    label.alpha = 0
                
                }, completion: { (_) in
                    label.removeFromSuperview()
                })
                
            })
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 0, green: 175, blue: 169)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        setupTextFieldAndButton()
        navigationItem.title = "Forgot Password"
        
        
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
