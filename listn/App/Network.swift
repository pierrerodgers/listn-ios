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
    var tokenManger : GraphQLTokenManager?
    
    private(set) lazy var apollo: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(url: URL(string: "https://realm.mongodb.com/api/client/v2.0/app/listn-graphql-gdipr/graphql")!)
        httpNetworkTransport.delegate = self
        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
    
}

extension Network : HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        request.addValue("Bearer \(tokenManger?.accessToken ?? "")", forHTTPHeaderField: "Authorization")
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        return true
    }
}

class GraphQLTokenManager {
    
    var accessToken: String?
    var refreshToken : String?
    var timer : Timer?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 60*25, repeats: true) { timer in
            self.refreshAccessToken()
        }
        getToken()
    }
    
    func getToken() {
        let url = URL(string: "https://realm.mongodb.com/api/client/v2.0/app/listn-graphql-gdipr/auth/providers/anon-user/login")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with:request) {(data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.accessToken = responseJSON["access_token"] as? String ?? ""
                self.refreshToken = responseJSON["refresh_token"] as? String ?? ""
            }
        }
        task.resume()
    }
    
    func refreshAccessToken() {
        let url = URL(string: "hhttps://realm.mongodb.com/api/client/v2.0/auth/session")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(refreshToken!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with:request) {(data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.accessToken = responseJSON["access_token"] as? String ?? ""
            }
        }
        task.resume()
    }
}
