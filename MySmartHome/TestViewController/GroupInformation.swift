//
//  GroupInformation.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-12.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

// MARK: - GroupList
struct GroupList: Codable {
    
    let group: [GroupInformation] = []
}

// MARK: - GroupInformation
struct GroupInformation: Codable {
    let id: String
    let name: String
    let state: String
    let statevalue: String
    let statevalues: [StateValue?] = []
    let methods: String
    let type: String
    let client: String
    let welcomeProtocol: String
    let model: String?
    let online: String
    let editable: Int
    let parameter: [Parameter] = []
    let devices: String
}

// MARK: - Parameter
struct Parameter: Codable {
    let name: String
    let value: String
}
