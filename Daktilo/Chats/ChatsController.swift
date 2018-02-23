//
//  ChatsController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 27.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class ChatsController: UITableViewController {
    private let cellId = "cellId"
    
    
    private func fetchUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("User-messages").child(uid)
        ref.observe(.childAdded , with: { (snapshot) in
            print(snapshot.key)
            Database.database().reference().child("User-messages").child(uid).child(snapshot.key).observe(.childAdded, with: { (snapshot) in
                self.fetchMessages(key: snapshot.key)
            }, withCancel: nil)
          
           
            
        }) { (err) in
            print(err)
            return
        }
        
    }
    
    
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    private func fetchMessages(key : String){
        let ref = Database.database().reference().child("Messages").child(key)
        ref.observe( .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let message = Message.init(dictionary: dictionary)
            //self.messages.append(message)
            
                self.messagesDictionary[message.chatPartnerId()] = message
           
            
            self.attemptReloadTable()
            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
            self.messages.forEach({ (mess) in
                print(mess.message)
            })
            
        }) { (err) in
            print("Failed to fetch messages",err)
        }
        ref.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadTable()
        }, withCancel: nil)
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    
    var timer : Timer?
    @objc func handleReload() {
        
        self.messages = Array(self.messagesDictionary.values)
        
        self.messages.sort(by: { (m1, m2) -> Bool in
            return m1.timeStamp.intValue > m2.timeStamp.intValue
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        
        let chatPartner : String?
        
        if message.fromId == Auth.auth().currentUser?.uid {
            chatPartner = message.toId
        }
        else {
            chatPartner = message.fromId
        }
        
        let ref = Database.database().reference().child("Users").child(chatPartner!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let user = UserWithUid.init(uid: message.toId, dictionary: dictionary)
            cell.textLabel?.text = user.username
            cell.profileImageView.loadImage(urlString: user.profileImageUrl)
            print(message.timeStamp)
            
            let timestampDate = Date(timeIntervalSince1970: message.timeStamp.doubleValue)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            cell.timeLabel.text = dateFormatter.string(from: timestampDate)
            
            
            
        }) { (err) in
            print("Failed to fetch user",err)
        }
        if message.imageUrl != "" && message.videoUrl != "" {
            
            cell.detailTextLabel?.text = "Video"
        }
        else if message.imageUrl != ""{
            cell.detailTextLabel?.text = "Image"
        }
        else {
        cell.detailTextLabel?.text = message.message
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func showChatLogController(user: UserWithUid){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = messages[indexPath.row]
        
         let chatPartnerId = user.chatPartnerId()
      //  let contacts = ContactsController()
        
        let ref = Database.database().reference().child("Users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let userWithUid = UserWithUid.init(uid: snapshot.key, dictionary: dictionary)
        self.showChatLogController(user: userWithUid)
            
            
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = messages[indexPath.row]
        
        Database.database().reference().child("User-messages").child(uid).child(chatPartnerId.chatPartnerId()).removeValue { (err, ref) in
            if let err = err {
                print("Failed to remove value",err)
            }
            self.messagesDictionary.removeValue(forKey: chatPartnerId.chatPartnerId())
            self.attemptReloadTable()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Chats"
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
       // fetchMessages()
        fetchUserMessages()
        tableView.allowsMultipleSelectionDuringEditing = true
        
          }
  
}
