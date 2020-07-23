//
//  LoginViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit

class LoginViewModel: ObservableObject {
    @Published var hasError : Bool = false
    @Published var error : String?
    @Published var isLoggedIn : Bool = false
    
    let loginService : LoginService
    
    init(loginService:LoginService) {
        self.loginService = loginService
    }
    
    func logIn(username:String, password:String) {
        loginService.logIn(username: username, password: password, completion: {error in
            guard error == nil else {
                self.error = error!.localizedDescription
                self.hasError = true
                return
            }
            
            self.isLoggedIn = true
        })
    }
    
    func signUp(username:String, password:String) {
        loginService.signUp(username: username, password: password, completion: {error in
            guard error == nil else {
                self.error = error!.localizedDescription
                self.hasError = true
                return
            }
            self.isLoggedIn = true
        })
    }
    
    
    
    
}
