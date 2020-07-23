//
//  App.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation
import RealmSwift

protocol LoginService {
    func signUp(username:String, password:String)
    
    func logIn(username:String, password:String)
    
    isLoggedIn : Bool
    
    error : String?
    
}

class MongoLoginService : LoginService {
    // We assume that app is intitialised
    var app : RealmApp
    
    
    init(app:RealmApp) {
        self.app = app
    }
    
    func signUp(username: String, password: String) {
        app.usernamePasswordProviderClient().registerEmail(username, password:password, completion: { error in
            guard error == nil else {
                print("Signup failed")
                self.error = error
                return
            }
            print("Signup successful")
            self.logIn(username: username, password: password)
        })
    }
    
    func logIn(username: String, password: String) {
        app.login(withcredential:AppCredentials(username: username, password:password)) { [weak self] in
            self!.isLoggedIn = true
        }
    }
}
