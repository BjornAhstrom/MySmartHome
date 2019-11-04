//
//  MainTabBarController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    
    func setupTabBar() {
        
        let firstViewController = FirstViewController()
        firstViewController.view.backgroundColor = .blue
        firstViewController.title = "First"
        
        let secondViewController = SecondViewController()
        secondViewController.view.backgroundColor = .orange
        secondViewController.title = "Second"
        
        let thirdViewController = ThirdViewController()
        thirdViewController.view.backgroundColor = .purple
        thirdViewController.title = "Devices"
        
        self.viewControllers = [firstViewController, secondViewController, thirdViewController]
    }
}
