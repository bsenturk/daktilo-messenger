//
//  MainTabBarController.swift
//  Daktilo
//
//  Created by Burak Şentürk on 27.09.2017.
//  Copyright © 2017 Burak Şentürk. All rights reserved.
//

import UIKit
import Firebase
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupViewControllers()
        
//        if Auth.auth().currentUser == nil {
//            DispatchQueue.main.async {
//                self.view.isHidden = true
//                let loginController = LoginController()
//                self.present(loginController, animated: true, completion: nil)
//            }
//            
//        }
        
        
    }
    
    
    func setupViewControllers() {
        tabBar.tintColor = .black
        
        let layout = UICollectionViewFlowLayout()
        
        let settingsController = templatesNavController(image: #imageLiteral(resourceName: "icons8-Settings-50"), title: "Settings", rootViewController: SettingsController())
        let chatsController = templatesNavController(image: #imageLiteral(resourceName: "icons8-Speech Bubble with Dots-50-2"), title: "Chats", rootViewController: ChatsController())
        let contactsController = templatesNavController(image: #imageLiteral(resourceName: "icons8-Male User-50"), title: "Contacts", rootViewController: ContactsController(collectionViewLayout: layout))
            viewControllers = [contactsController,chatsController,settingsController]
    }
    
    func templatesNavController(image : UIImage, title : String , rootViewController : UIViewController) -> UINavigationController {
        
        
        let viewController = rootViewController
        let navControllers = UINavigationController(rootViewController: viewController)
        navControllers.tabBarItem.image = image.withRenderingMode(.alwaysOriginal)
        navControllers.tabBarItem.title = title
        
        return navControllers
    }
}
