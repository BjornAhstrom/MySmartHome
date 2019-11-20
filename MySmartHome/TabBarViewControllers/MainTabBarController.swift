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
        setTelldusKeys()
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let startViewController = ViewController()
        startViewController.title = "Groups"
        
        let scenariosViewController = ScenariosViewController()
        scenariosViewController.title = "Scenarios"
        
        let allDevicesViewController = AllDevicesController() //AllDevicesViewController()
        allDevicesViewController.title = "Devices"
        
        self.viewControllers = [startViewController, scenariosViewController, allDevicesViewController]
    }
    
    func setTelldusKeys() {
        TelldusKeys.oauthswift.client.credential.oauthToken = TelldusKeys.token
        TelldusKeys.oauthswift.client.credential.oauthTokenSecret = TelldusKeys.token_secret
        
        GetInfoAboutAllDevices.instance.getDevicesInfo(url: "https://api.telldus.com/json/devices/list")
        GetInfoAboutGroups.instance.getGroupsInfo(url: "https://api.telldus.com/json/devices/list")
    }
}

// Hide keboard
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
