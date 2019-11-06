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
        
        let startViewController = ViewController()
        startViewController.view.backgroundColor = .white
        startViewController.title = "Start"
        
        let scenariosViewController = ScenariosViewController()
        scenariosViewController.view.backgroundColor = .orange
        scenariosViewController.title = "Scenarios"
        
        let allDevicesViewController = AllDevicesViewController()
        allDevicesViewController.view.backgroundColor = .purple
        allDevicesViewController.title = "Devices"
        
        self.viewControllers = [startViewController, scenariosViewController, allDevicesViewController]
    }
}
