//
//  GetInfoAboutGroups.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-12.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class GetInfoAboutGroups {
    
    private init() {}
    static let instance = GetInfoAboutGroups()
    
    var groups: [GroupInformation] = []
    
    var groupCount: Int {
        return groups.count
    }

    func getGroupsInfo(url: String) {
        TelldusKeys.oauthswift.client.get(url) { result in
            switch result {
            case .success(let response):
                let dataString = response.string
                
                let jsonData = dataString!.data(using: .utf8)
                let decoder = JSONDecoder()
                let groups = try! decoder.decode(GroupList.self, from: jsonData!)

                
                let group = groups.group
                for gro in group {
                    self.groups.append(gro)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func groups(index: Int) -> GroupInformation? {
        if index >= 0 && index <= groups.count && !groups.isEmpty {
            return groups[index]
        }
        return nil
    }
}
