//
//  DeviceInformation.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-12.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

// MARK: - DeviceList
//struct DeviceList: Codable {
//    
//    let device: [DeviceInformation?] = []
//}

// MARK: - DeviceInformation
struct DeviceInformation: Codable {
    var id: String?
    var clientDeviceID: String?
    var name: String?
    var state: Int?
    var statevalue: String?
    var stateValues: [StateValue?] = []
    var methods: Int?
    var metadataHash: String?
    var parametersHash: String?
    var type: String?
    var client: String?
    var clientName: String?
    var online: String?
    var editable: Int?
    var ignored: Int?
}

// MARK: - StateValue
struct StateValue: Codable {
    var state: String?
    var value: String?
}



