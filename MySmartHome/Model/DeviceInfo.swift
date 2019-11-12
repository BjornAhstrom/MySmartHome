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
