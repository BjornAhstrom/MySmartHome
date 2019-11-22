//
//  ClientInfo.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-21.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

struct ClientsList: Codable {
    var clients: [Client]?
}

struct Client: Codable {
    
    var id: String?
    var uuid: String?
    var name: String?
    var online: String?
    var editable: Int?
    var extensions: Int?
    var version: String?
    var type: String?
    var ip: String?
}
