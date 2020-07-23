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
    func signUp(email:String, password:String)
    
    func logIn(email:String, password:String)
    
}

class MongoLoginService : LoginService {
    var app : RealmApp
    
    init(app:RealmApp) {
        self.app = app
    }
    
    func signUp(email: String, password: String) {
        
    }
    
    func logIn(email: String, password: String) {
        
    }
}
