//
//  CustomTabBarController.swift
//  FacebookFeed
//
//  Created by Armin Spahic on 05/12/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let navigationController = UINavigationController(rootViewController: FeedController(collectionViewLayout: layout))
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestsController = FriendRequestsController()
        friendRequestsController.navigationItem.title = "Requests"
        let secondNavController = UINavigationController(rootViewController: friendRequestsController)
        secondNavController.title = "Requests"
        secondNavController.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messengerController = UIViewController()
        messengerController.navigationItem.title = "Messenger"
        let thirdNavController = UINavigationController(rootViewController: messengerController)
        thirdNavController.title = "Messenger"
        thirdNavController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationsNavController = UIViewController()
        notificationsNavController.navigationItem.title = "Notifications"
        let fourthNavController = UINavigationController(rootViewController: notificationsNavController)
        fourthNavController.title = "Notifications"
        fourthNavController.tabBarItem.image = UIImage(named: "comment")
        
        let moreNavController = UIViewController()
        moreNavController.title = "More"
        moreNavController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers = [navigationController, secondNavController, thirdNavController, fourthNavController, moreNavController]
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.2)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true     
    }
}
