//
//  ApiManager.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-25.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

struct ApiManager {
    
    static var deviceInfo: [Deviceinfo] = []
    static var deviceStatus: [DeviceHistory] = []
    
    // "https://api.telldus.com/json/devices/list"
    
    // MARK: getAlldevicesRequest
    static func getAlldevicesRequest(onCompletion: @escaping (DeviceList) -> Void) {
       TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/devices/list") { result in
           switch result {
           case .success(let response):
               let dataString = response.string
               
               let jsonData = dataString!.data(using: .utf8)
               let decoder = JSONDecoder()
               let device = try! decoder.decode(DeviceList.self, from: jsonData!)
               
               onCompletion(device)
               
           case.failure(let error):
               print(error.localizedDescription)
           }
       }
    }
    
    // MARK: turnOnDevice, the id of the device to turn on lamp
    static func turnOnDevice(id: String) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/turnOn?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                print(dataString ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: turnOffDevice, the id of the device to turn off lamp
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
    
    // MARK: Dimmable: The id of the device to dim lamp
    static func dimmableLamp(id: String, dimValue: Int) {
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
    
    // MARK: Device Information: The id of the device to get info
    static func getDeviceInformation(id: String, onCompletion: @escaping (String, String, String) -> Void ) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/info?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(Deviceinfo.self, from: jsonData!)
                
//                self.deviceInfo.append(device)
                onCompletion(device.statevalue ?? "", device.deviceType ?? "", device.type ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: getGroupInformation, The id of the group to get info
    static func getGroupInformation(id: String, onCompletion: @escaping (String) -> Void ) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/info?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(Deviceinfo.self, from: jsonData!)
                
                onCompletion(device.name ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: getGroupDevicesId, The id of the group to get all devices id in group
    static func getGroupDevicesId(id: String, onCompletion: @escaping (String) -> Void ) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/info?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(Deviceinfo.self, from: jsonData!)
                
                onCompletion(device.devices ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: setNewDeviceName, the id of the device and the new name to change name of the device
    static func setNewDeviceName(id: String, name: String) {
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
    
    // MARK: createNewDeviceGroupName, The id of the client, the name of the group and a comma seperated string with the devices ids this group should control
    static func createNewDeviceGroupName(clientId: String, groupName: String, devices: String, onCompletion: @escaping (String, Int) -> Void) {
        
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/group/add?clientId=\(clientId)&name=\(groupName)&devices=\(devices)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(MessageFromTelldus.self, from: jsonData!)
                
                print(device)
                if device.error == nil {
                    onCompletion(device.status ?? "", device.id ?? 0)
                } else {
                    onCompletion(device.error ?? "", device.id ?? 0)
                }
                
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: removeGroup, The id from the group to remove group
    static func removeGroup(groupId: String, onCompletion: @escaping (String, String) -> Void ) {
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/group/remove?id=\(groupId)") { result in // gör en completionhandler och tillsätt på remove group button
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let device = try! decoder.decode(MessageFromTelldus.self, from: jsonData!)
                
                onCompletion(device.status ?? "", device.error ?? "")
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: learnDeviceToConnect, The id of the device to learn
    static func learnDeviceToConnect(id: String) {
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
    
    // MARK: getHistory, The id of the device to find history from a specific device to get the state value
    static func getHistory(id: String, onCompletion: @escaping (_ state: Int, _ stateValue:Int) -> Void ) {
        
        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/history?id=\(id)") { result in
            switch result {
            case.success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let deviceHistory = try! decoder.decode(DeviceHistorys.self, from: jsonData!)
                
                for devHis in deviceHistory.history ?? [] {
                    
                    self.deviceStatus.append(devHis)
                }
                
                if let state = self.deviceStatus.last { // Tar ut det sista värdet som registrerades och skickar vidare det
                    onCompletion(state.state ?? 0, state.stateValue ?? 0)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
