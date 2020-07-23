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
    func signUp(username:String, password:String, completion:@escaping (Error?) -> Void)
    
    func logIn(username:String, password:String, completion:@escaping (Error?) -> Void)
    
}

class MongoLoginService : LoginService {
    
    // We assume that app is intitialised
    private var app : RealmApp
    
    
    init(app:RealmApp) {
        self.app = app
    }
    
    func signUp(username: String, password: String, completion: @escaping (Error?) -> Void) {
        app.usernamePasswordProviderClient().registerEmail(username, password:password, completion: { error in
            guard error == nil else {
                print("Signup failed")
                completion(error)
                return
            }
            print("Signup successful")
            self.logIn(username: username, password: password, completion: completion)
        })
    }
    
    func logIn(username: String, password: String, completion:@escaping (Error?) -> Void) {
        print(username)
        print(password)
        let credentials = AppCredentials(username: username, password: password)
        print(credentials)
        app.login(withCredential:AppCredentials(username: username, password: password), completion: {user, error in
            completion(error)
        })
    }
}
