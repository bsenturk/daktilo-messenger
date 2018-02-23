//
//  ChatMessageCell.swift
//  Daktilo
//
//  Created by Burak Şentürk on 21.10.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import AVFoundation
class ChatMessageCell: UICollectionViewCell {
    var messages : Message?
    
    var chatLogController : ChatLogController?
    
    let messageView : UITextView = {
       let label = UITextView()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    let bubbleView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
        
    }()
    lazy var imageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomImage)))
        return iv
    }()
    
    lazy var playButton : UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return button
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
       let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    var playerLayer : AVPlayerLayer?
    var player : AVPlayer?
    @objc func handlePlay() {
        if let urlString = messages?.videoUrl, let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            playButton.isHidden = true
            activityIndicator.startAnimating()
            
            player?.play()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicator.stopAnimating()
    }
    
    var bubbleWidth : NSLayoutConstraint?
    var bubbleLeftAnchor : NSLayoutConstraint?
    var bubbleRightAnchor : NSLayoutConstraint?
    func setupMessageLabel() {
        addSubview(bubbleView)
        addSubview(messageView)
        bubbleView.addSubview(imageView)
        
        imageView.anchor(topAnchor: bubbleView.topAnchor, leftAnchor: bubbleView.leftAnchor, bottomAnchor: bubbleView.bottomAnchor, rightAnchor: bubbleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        
        bubbleView.anchor(topAnchor: topAnchor, leftAnchor: nil, bottomAnchor: nil, rightAnchor: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
       bubbleWidth = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidth?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
      

        
        
        messageView.anchor(topAnchor: topAnchor, leftAnchor: bubbleView.leftAnchor, bottomAnchor: nil, rightAnchor: bubbleView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        messageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    @objc func handleZoomImage(tapGesture : UITapGestureRecognizer) {
        
        if messages?.videoUrl != "" {
            return
        }
        let imageView = tapGesture.view as? UIImageView
        self.chatLogController?.zoomInImageView(imageView: imageView!)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMessageLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
