//
//  Network.swift
//  listn
//
//  Created by Pierre Rodgers on 27/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation
import Apollo
import RealmSwift

class Network {
    static let shared = Network()
    var app : RealmApp?
    private(set) lazy var apollo: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(url: URL(string: "https://realm.mongodb.com/api/client/v2.0/app/listn-bsliv/graphql")!)
        httpNetworkTransport.delegate = self
        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
}

extension Network : HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        let token = app!.currentUser()!.accessToken!
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        return true
    }
}
