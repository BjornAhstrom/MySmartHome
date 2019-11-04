//
//  DevicesInput.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DevicesInput {
    
    static var devices: [Deviceinfo] = []
    
    static func getDevicesInfo(tableView: UITableView, url: String) {
                TelldusKeys.oauthswift.client.get(url) { result in
                    switch result {
                    case .success(let response):
                        let dataString = response.string
                        
                        let jsonData = dataString!.data(using: .utf8)
                        let decoder = JSONDecoder()
                        let device = try! decoder.decode(DeviceList.self, from: jsonData!)
                        
                        let devi = device.device
                        for dev in devi {
                            self.devices.append(dev)
                            
//                        print("name: \(dev.name)    id: \(dev.id)")
                        }
                        tableView.reloadData()
                        
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
}
