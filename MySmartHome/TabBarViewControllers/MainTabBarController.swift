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
        scenariosViewController.title = "Scenarios"
        
        let allDevicesViewController = AllDevicesViewController()
        allDevicesViewController.title = "Devices"
        
        self.viewControllers = [startViewController, scenariosViewController, allDevicesViewController]
    }
}

extension UIViewController {
    
    func hideKeyBoard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
}
