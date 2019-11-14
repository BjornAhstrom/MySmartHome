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
    
    
    var devices: [Deviceinfo] = []
    var deviceStatus: [DeviceHistory] = []
    
    var deviceCount: Int {
        return devices.count
    }
    
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
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(DeviceInforma.self, from: jsonData!)
                
                print(device)
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // The id of the group to get info
    func getGroupInformation(id: String, onCompletion: @escaping (String) -> Void ) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/info?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(DeviceInforma.self, from: jsonData!)
                
                //                print("devId: \(device.id), devNAme: \(device.name), devState: \(device.state), devType: \(device.type) ")
                onCompletion(device.name)
                
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
    
    // The id from the group to remove group
    func removeGroup(deviceId: String) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/group/remove?id=\(deviceId)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(MessageFromTelldus.self, from: jsonData!)
                
                print("\(device)")
                
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
    
    // The id of the device to find history from a specific device to get the state value
    func getHistory(id: String, onCompletion: @escaping (Int) -> Void ) {
        
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/history?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let deviceHistory = try! decoder.decode(DeviceHistorys.self, from: jsonData!)
                
                for devHis in deviceHistory.history {
                    
                    self.deviceStatus.append(devHis)
                }
                
                if let test = self.deviceStatus.last {
                    onCompletion(test.state ?? 0)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    // The id of the device to find history from a specific device to get the state value
    func getHistory1(id: String, onCompletion: @escaping (Int) -> Void ) {
        
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/history?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let deviceHistory = try! decoder.decode(DeviceHistory.self, from: jsonData!)
                
                onCompletion(deviceHistory.state ?? 0)
                
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
