//
//  DeviceInfoOutput.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DeviceInfoOutput {
    
    private init() {}
    static let instance = DeviceInfoOutput()
    
    // the id of the device to turn on lamp
    func turnOnDevice(id: String) {
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
    
    // the id of the device to turn off lamp
    func turnOffDevice(id: String) {
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
    
    // The id of the device to dim lamp
    func dimmableLamp(id: String, dimValue: Float) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/dim?id=\(id)&level=\(dimValue)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                print(dataString ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // The id of the device to get info
    func getDeviceInformation(id: String) {
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
    
    // the id of the device and the new name to change name of the device
    func setNewDeviceName(id: String, name: String) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/setName?id=\(id)&name=\(name)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                print(dataString ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //The id of the client, the name of the group and a comma seperated string with the devices ids this group should control
    func createNewDeviceGroupName(clientId: String, groupName: String, devices: String, onCompletion: @escaping (String) -> Void) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/group/add?clientId=\(clientId)&name=\(groupName)&devices=\(devices)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(MessageFromTelldus.self, from: jsonData!)
                
                if device.error == nil {
                    onCompletion(device.status ?? "")
                } else {
                    onCompletion(device.error ?? "")
                }
                
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // The id of the device to learn
    func learnDeviceToConnect(id: String) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/learn?id=\(id)") { result in
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
