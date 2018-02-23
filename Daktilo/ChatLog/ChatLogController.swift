//
//  ChatLogController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 7.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
class ChatLogController: UICollectionViewController,UICollectionViewDelegateFlowLayout , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user : UserWithUid? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            fetchMessages()
        }
    }
    
    //Create Views
    let inputContainerView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let navigationTitleView : UIView = {
       let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 350, height: 60)
        view.backgroundColor = .red
        return view
    }()
    
    lazy var profileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSeeProfileImage)))
        return iv
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "asdasd"
       return label
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send-2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        return button
    }()
    let plusButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.addTarget(self, action: #selector(handleSendImageVideo), for: .touchUpInside)
        return button
    }()
    
    let inputTextField : CustomInputTF = {
       let tf = CustomInputTF()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.1)
        tf.layer.cornerRadius = 10
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let seperatorView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
       let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.hidesWhenStopped = true
        return ai
    }()
    
   
    //Create View's Functions
    
    var inputContainerViewBottom : NSLayoutConstraint?
    private func setupInputContainerView(){
        view.addSubview(inputContainerView)
        
        inputContainerView.anchor(topAnchor: nil, leftAnchor: view.leftAnchor, bottomAnchor: nil, rightAnchor: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        inputContainerViewBottom = inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        inputContainerViewBottom?.isActive = true
        
        //Send Button
        inputContainerView.addSubview(sendButton)
        sendButton.anchor(topAnchor: nil, leftAnchor: nil, bottomAnchor: nil, rightAnchor: inputContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        
        //Plus Button
        inputContainerView.addSubview(plusButton)
        plusButton.anchor(topAnchor: nil, leftAnchor: inputContainerView.leftAnchor, bottomAnchor: nil, rightAnchor: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        plusButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        
        //Input Text Field
        inputContainerView.addSubview(inputTextField)
        inputTextField.anchor(topAnchor: inputContainerView.topAnchor, leftAnchor: plusButton.rightAnchor, bottomAnchor: inputContainerView.bottomAnchor, rightAnchor: sendButton.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: -8, paddingRight: 0, width: 0, height: 0)
        
        //Seperator View
        view.addSubview(seperatorView)
        seperatorView.anchor(topAnchor: nil, leftAnchor: view.leftAnchor, bottomAnchor: inputContainerView.topAnchor, rightAnchor: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    private func setupNavBar() {
//        navigationTitleView.addSubview(profileImageView)
        navigationTitleView.addSubview(profileImageView)
        profileImageView.anchor(topAnchor: nil, leftAnchor: navigationTitleView.leftAnchor, bottomAnchor: nil, rightAnchor: nil, paddingTop: 0, paddingLeft: -30, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        profileImageView.layer.cornerRadius = 20
        
        navigationTitleView.addSubview(usernameLabel)
        usernameLabel.anchor(topAnchor: nil, leftAnchor: profileImageView.rightAnchor, bottomAnchor: nil, rightAnchor: navigationTitleView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: navigationTitleView.centerYAnchor).isActive = true
       
        navigationItem.titleView = navigationTitleView
        
        
    }
    
   
    
    func scrollToBottom() {
        let section = (collectionView?.numberOfSections)! - 1
        let lasItemIndex = IndexPath(item : self.messages.count - 1, section : section)
        self.collectionView?.scrollToItem(at: lasItemIndex, at: .bottom, animated: true)
        
    }
    
    @objc func handleSendMessage() {
        let ref = Database.database().reference().child("Messages").childByAutoId()
        guard let fromId = Auth.auth().currentUser?.uid else {
            return
        }
        guard let toId = user?.uid else {
            return
        }
        let timestamp =  Date().timeIntervalSince1970
        let values = ["toId": toId,
                      "message" : inputTextField.text!,
                      "timeStamp" : timestamp,
                      "fromId" : fromId
        
        ] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to send message",err)
            }
            print("Successfully to send message")
            self.inputTextField.text = nil
            self.scrollToBottom()
        
            
        }
        let messageId = ref.key
        let messageIdValues = [messageId : 1]
        Database.database().reference().child("User-messages").child(fromId).child(toId).updateChildValues(messageIdValues)
        
        Database.database().reference().child("User-messages").child(toId).child(fromId).updateChildValues([ref.key : 1])
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    let cellId = "cellId"
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.messageView.text = message.message
        setupCell(cell: cell, message: message)
        cell.chatLogController = self
        cell.messages = message
        
       
        
        
        
        if message.imageUrl != "" {
            cell.bubbleWidth?.constant = 200
            cell.messageView.isHidden = true
            cell.imageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        }
        else {
            cell.bubbleWidth?.constant = estimateFrameForText(text: message.message).width + 32
            cell.messageView.isHidden = false
            cell.imageView.isHidden = true
        }
        
        if message.videoUrl != "" {
            
            cell.playButton.isHidden = false
        }else {
            cell.playButton.isHidden = true
        }
        
        return cell
    }
    
    private func setupCell(cell : ChatMessageCell , message : Message) {
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
            cell.messageView.textColor = .white
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        }else {
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.messageView.textColor = .black
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
            cell.imageView.loadImage(urlString: message.imageUrl)
        
       
        
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height : CGFloat = 80
    
         let text = messages[indexPath.item].message
        height = estimateFrameForText(text: text).height + 20
    
        let imageUrl = messages[indexPath.item]
        if imageUrl.imageUrl != ""{
      let imageWidth = imageUrl.imageWidth.floatValue
            let  imageHeight = imageUrl.imageHeight.floatValue
           height = CGFloat(imageHeight / imageWidth * 200)
          // height = 200
            
    }
    
    
    
        return CGSize(width: view.frame.width, height: height)
    
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var messages = [Message]()
    func fetchMessages(){
        guard let uid = Auth.auth().currentUser?.uid,let userId = user?.uid else { return }
        
        let ref = Database.database().reference().child("User-messages").child(uid).child(userId)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            self.fetchUsersMessages(messageId: messageId)
            
      
            
        }, withCancel: nil)
        
    }
    
    func fetchUsersMessages(messageId : String) {
        let messageRef = Database.database().reference().child("Messages").child(messageId)
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let message = Message.init(dictionary: dictionary)
          
            
            if message.chatPartnerId() == self.user?.uid {
                  self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    let lasItem = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: lasItem, at: .bottom, animated: false)
                }
            }
            
          
            
        }, withCancel: nil)
        
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: .UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: .UIKeyboardDidShow, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardShow(notification : Notification) {
        
        let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        inputContainerViewBottom?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardHide(notification : Notification) {
        inputContainerViewBottom?.constant = 0
    let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func handleInputChange() {
        if inputTextField.text?.count ?? 0 > 0 {
            sendButton.isEnabled = true
        }
        else {
            sendButton.isEnabled = false
        }
    }
    
    
    
    
    @objc func handleSeeProfileImage() {
     print(123)
    }
    
    @objc func handleSendImageVideo() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            
            self.handleVideoSelectForUrl(url: videoUrl)
            
        }
        
        var selectedImageFromPicker : UIImage?
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage.withRenderingMode(.alwaysOriginal)
            
            
        }
        else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
           selectedImageFromPicker = editedImage.withRenderingMode(.alwaysOriginal)
            
        }
        
        if let selectedImage = selectedImageFromPicker {
           // uploadToFirebaseStorage(image: selectedImage)
            uploadToFirebaseStorage(image: selectedImage, completion: { (imageUrl) in
                
                self.sendImageMessage(imageUrl: imageUrl, image: selectedImage)
            })
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func handleVideoSelectForUrl(url : URL) {
        let fileName = NSUUID().uuidString + ".mov"
     Storage.storage().reference().child("message_videos").child(fileName).putFile(from: url, metadata: nil, completion: { (metadata, err) in
            if let err = err {
                print("Failed to upload video storage",err)
            }
            
            if let storageUrl = metadata?.downloadURL()?.absoluteString {
                print(storageUrl)
                if let thumbnailImage = self.thumbnailImage(fileUrl: url) {
                    
                    self.uploadToFirebaseStorage(image: thumbnailImage, completion: { (imageUrl) in
                        
                        self.sendVideoMessage(imageUrl : imageUrl,videoUrl: storageUrl, imageWidth: thumbnailImage.size.width, imageHeight: thumbnailImage.size.height)
                    })
                
                 
                    
                }
            }
          
        })
        
    }
    
    private func thumbnailImage(fileUrl : URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImageCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImageCGImage)
        }catch let err {
            print(err)
        }
        return nil
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadToFirebaseStorage(image : UIImage ,completion : @escaping (_ imageUrl : String) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageName = NSUUID().uuidString
       
        guard let uploadData = UIImageJPEGRepresentation(image, 0.2) else { return }
        Storage.storage().reference().child("message_images").child(uid).child(imageName).putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                print("Failed to upload image :",err)
            }
            print("Successfully to upload image")
            if let imageUrl = metadata?.downloadURL()?.absoluteString {
                //self.sendImageMessage(imageUrl: imageUrl , image : image)
                completion(imageUrl)
            
            }
            
        }
        
        
    }
    
    private func sendImageMessage(imageUrl : String, image : UIImage ){
        
        let ref = Database.database().reference().child("Messages").childByAutoId()
        guard let fromId = Auth.auth().currentUser?.uid else {
            return
        }
        guard let toId = user?.uid else {
            return
        }
        let timestamp =  Date().timeIntervalSince1970
        let values = ["toId": toId,
                      "imageUrl" : imageUrl,
                      "timeStamp" : timestamp,
                      "fromId" : fromId,
            "imageWidth" : image.size.width,
            "imageHeight" : image.size.height
            
            ] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to send message",err)
            }
            print("Successfully to send message")
            self.inputTextField.text = nil
            self.scrollToBottom()
            
            
        }
        let messageId = ref.key
        let messageIdValues = [messageId : 1]
        Database.database().reference().child("User-messages").child(fromId).child(toId).updateChildValues(messageIdValues)
        
        Database.database().reference().child("User-messages").child(toId).child(fromId).updateChildValues([ref.key : 1])
        
        
    }
    
    private func sendVideoMessage(imageUrl : String,videoUrl : String , imageWidth : CGFloat , imageHeight: CGFloat) {
        let ref = Database.database().reference().child("Messages").childByAutoId()
        
        guard let fromId = Auth.auth().currentUser?.uid else {
            return
        }
        guard let toId = user?.uid else {
            return
        }
        let timestamp =  Date().timeIntervalSince1970
        let values = ["toId": toId,
                      "videoUrl" : videoUrl,
                      "timeStamp" : timestamp,
                      "fromId" : fromId,
                      "imageWidth" : imageWidth,
                      "imageHeight" : imageHeight,
                      "imageUrl" : imageUrl
            
            ] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to send message",err)
            }
            print("Successfully to send message")
            self.scrollToBottom()
        
        }
        
        let messageId = ref.key
        let messageIdValues = [messageId : 1]
        Database.database().reference().child("User-messages").child(fromId).child(toId).updateChildValues(messageIdValues)
        
        Database.database().reference().child("User-messages").child(toId).child(fromId).updateChildValues([ref.key : 1])
        
    }
    
    var startingFrame : CGRect?
    var backgroundView : UIView?
    func zoomInImageView(imageView : UIImageView) {
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        print(startingFrame!)
        let zoomView = UIImageView(frame: startingFrame!)
        zoomView.backgroundColor = .red
        zoomView.image = imageView.image
        zoomView.isUserInteractionEnabled = true
        zoomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keyWindow = UIApplication.shared.keyWindow {
            backgroundView = UIView(frame: keyWindow.frame)
            backgroundView?.backgroundColor = .black
            backgroundView?.alpha = 0
            keyWindow.addSubview(backgroundView!)
            
            
            keyWindow.addSubview(zoomView)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                
                self.backgroundView?.alpha = 1
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGesture : UITapGestureRecognizer) {
        if let zoomOut = tapGesture.view {
            zoomOut.layer.cornerRadius = 16
            zoomOut.clipsToBounds = true
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                zoomOut.frame = self.startingFrame!
                self.backgroundView?.alpha = 0
                
            }, completion: { (completion : Bool) in
                
                zoomOut.removeFromSuperview()
                
            })
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
       collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white // UIColor(patternImage: UIImage(named: "chatBg")!)
        setupInputContainerView()
        setupNavBar()
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupKeyboard()
        
        collectionView?.keyboardDismissMode = .onDrag
    }
   
}
