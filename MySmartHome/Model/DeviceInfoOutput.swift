//
//  DeviceInfoOutput.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DeviceInfoOutput {
    
    static func turnOnDevice(id: String) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/turnOn?id=\(id)") { result in
            print(id)
            switch result {
            case.success(let response):
                let dataString = response.string
                
                print(dataString ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func turnOffDevice(id: String) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/turnOff?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                print(dataString ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func dimmableLamp(id: String, dimValue: Float) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/dim?id=\(id)?level=\(dimValue)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                print(dataString ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getDeviceInformation(id: String) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/info?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                print(dataString ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
