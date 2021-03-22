//
//  HomeController.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

class HomeController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transactionsController = UINavigationController(rootViewController: AccountsController())
        transactionsController.tabBarItem = UITabBarItem(title: "Accounts", image: UIImage(named: "accounts"), selectedImage: nil)
        
        let dashboardController = UINavigationController(rootViewController: DashboardController())
        dashboardController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard"), selectedImage: nil)
        
        viewControllers = [transactionsController, dashboardController]
    }
}
