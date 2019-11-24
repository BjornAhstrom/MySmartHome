//
//  MessageFromTelldus.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-13.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

struct MessageFromTelldus: Codable {
    let id: Int?
    let error: String?
    let status: String?
    let state: String?
}
