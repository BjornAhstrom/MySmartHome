//
//  DeviceInfoViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-05.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DeviceInfoViewController: UINavigationController {

    var nameLabel = UILabel()
    
    public var id: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 200, height: 50))
        
        print("!!!!!!!!!! ID: \(id)")
//        getDevicesInfo(url: "https://api.telldus.com/json/device/info?id=\(id)")
    }

    func getDevicesInfo(url: String) {
                    TelldusKeys.oauthswift.client.get(url) { result in
                        switch result {
                        case .success(let response):
                            let dataString = response.string
                            
                            let jsonData = dataString!.data(using: .utf8)
                            let decoder = JSONDecoder()
                            let device = try! decoder.decode(DeviceList.self, from: jsonData!)
                            
                            let devi = device.device
                            
                            for dev in devi ?? [] {
                                
                                self.nameLabel.text = dev.name
                            }
                            
                        case.failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
    }
    

