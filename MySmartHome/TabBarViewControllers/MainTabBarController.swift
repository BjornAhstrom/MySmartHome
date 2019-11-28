//
//  MainTabBarController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    let startViewController = ViewController()
    let scenariosViewController = ScenariosViewController()
    let allDevicesViewController = AllDevicesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTelldusKeys()
        setupTabBar()
    }
    
    
    func setupTabBar() {
        
        startViewController.title = "\(NSLocalizedString("groups", comment: ""))"
        
//        scenariosViewController.title = "Scenarios"
        
        allDevicesViewController.title = "\(NSLocalizedString("devices", comment: ""))"
        
        self.viewControllers = [startViewController, allDevicesViewController]
    }
    
    func setTelldusKeys() {
        TelldusKeys.oauthswift.client.credential.oauthToken = TelldusKeys.token
        TelldusKeys.oauthswift.client.credential.oauthTokenSecret = TelldusKeys.token_secret
        
//        GetInfoAboutGroups.instance.getGroupsInfo(url: "https://api.telldus.com/json/devices/list")
//        GetInfoAboutAllDevices.instance.getDevicesInfo(url: "https://api.telldus.com/json/devices/list")
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
    
    // MARK: Start activity indicator
    func startActivityIndicator(activityIndicator: UIActivityIndicatorView ) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    // MARK: Stop activity indicator
    func stopActivityIndicator(activityIndicator: UIActivityIndicatorView ) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
