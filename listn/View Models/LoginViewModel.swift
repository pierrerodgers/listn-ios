//
//  LoginViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewModel: ObservableObject {
    @Published var hasError : Bool = false
    @Published var error : String?
    @Published var isLoggedIn : Bool = false
    
    let loginService : LoginService
    
    init(loginService:LoginService) {
        self.loginService = loginService
        isLoggedIn = loginService.isLoggedIn
    }
    
    func logIn(username:String, password:String) {
        loginService.logIn(username: username, password: password, completion: {error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.error = error!.localizedDescription
                    self.hasError = true
                }
                return
            }
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
            
            Realm.asyncOpen(configuration: app.currentUser()!.configuration(partitionValue: ((app.currentUser()?.customData!["id"])!)!), callback: { maybeRealm, error in
                guard error == nil else {
                    print(error ?? "Error!")
                    return
                }
                let realm = maybeRealm!
                let albums = realm.objects(Album.self)
                print(albums)
            })
            
            
        })
    }
    
    func signUp(username:String, password:String) {
        loginService.signUp(username: username, password: password, completion: {error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.error = error!.localizedDescription
                    self.hasError = true
                }
                return
            }
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
            
            
        })
    }
    
    func logOut() {
        loginService.logOut(completion: { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
            
            
        })
    }
    
    
    
}
