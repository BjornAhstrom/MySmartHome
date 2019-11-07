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
    let id: String
    let name: String
//    let state: String
//    let statevalue: String
//    let methods: String
//    let type: String
//    let client: String
//    let online: String
//    let editable: Int
}
