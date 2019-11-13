//
//  GetInfoAboutAllDevices.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class GetInfoAboutAllDevices {
    
    private init() {}
    static let instance = GetInfoAboutAllDevices()
    
    var devices: [Deviceinfo] = []
    
    var deviceCount: Int {
        return devices.count
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
                for dev in devi {
                    self.devices.append(dev)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deviceClear() {
        devices = []
    }
    
    func devices(index: Int) -> Deviceinfo? {
        if index >= 0 && index <= devices.count && !devices.isEmpty {
            return devices[index]
        }
        return nil
    }
}
