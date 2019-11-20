//
//  TelldusKeys.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import OAuthSwift

class TelldusKeys {
    static let token = "7a6155f5d8977ffbf07c32c5946e2dd505c24b938"
    static let token_secret = "20322a1cca49b2b58929fde2de38c18e"
    
    static let dimmableDeviceNr = "00000005-0001-1000-2005-acca54000000"
    static let onOffDeviceNr = "00000010-0001-1000-2005-acca54000000"
    
    static let oauthswift = OAuth1Swift(
        consumerKey:    "FEHUVEW84RAFR5SP22RABURUPHAFRUNU", //Public
        consumerSecret: "ZUXEVEGA9USTAZEWRETHAQUBUR69U6EF"  //private
    )
    
}
