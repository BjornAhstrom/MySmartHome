//
//  DeviceInfo.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

struct DeviceList: Codable {
    
    let device : [Deviceinfo]
}

struct Deviceinfo: Codable {
    var id: String
    let name: String
    let type: String
    let devices: String?
}

struct DeviceInforma: Codable {
    let id: String
    let name: String
    let state: String
    let type: String
}

struct DeviceHistorys: Codable {
    let history: [DeviceHistory]
}

struct DeviceHistory: Codable {
    let ts: Int? //"ts": 1573728053,
    let state: Int?//"state": 2,
    let stateValue: Int? //"stateValue": 0,
    let origin: String? //"origin": "Telldus Live! mobile - iOS",
    let successStatus: Int? //"successStatus": 0
}

