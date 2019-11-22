//
//  GetInfoAboutClient.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-21.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class GetInfoAboutClient {
    
    private init() {}
    static let instance = GetInfoAboutClient()
    
    var clients: [Client] = []
    
    var clientCount: Int {
        return clients.count
    }
    
    func getClientInfo(url: String) {
           TelldusKeys.oauthswift.client.get(url) { result in
               switch result {
               case .success(let response):
                   let dataString = response.string
                   
                   let jsonData = dataString!.data(using: .utf8)
                   let decoder = JSONDecoder()
                   let client = try! decoder.decode(ClientsList.self, from: jsonData!)
                   
                   print(client)
//                   let clie = client.clients
//                   for cli in clie ?? [] {
//                       self.clients.append(cli)
//                    print(cli)
//                   }
                   
               case.failure(let error):
                   print(error.localizedDescription)
               }
           }
       }
    
    func clients(index: Int) -> Client? {
        if index >= 0 && index <= clients.count && !clients.isEmpty {
            return clients[index]
        }
        return nil
    }
}
