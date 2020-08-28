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
    @Published var signingUp : Bool = false
    @Published var finishedSignUp : Bool = false
    @Published var isLoggedIn : Bool = false
    @Published var usernameFree : Bool = true
    @Published var checkingUsername : Bool = true
    
    let loginService : LoginService
    let app : ListnApp
    
    private var timer : Timer?
    
    func debounce(seconds: TimeInterval, function: @escaping () -> Swift.Void ) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            function()
        })
    }
    
    
    init(loginService:LoginService, app: ListnApp) {
        self.loginService = loginService
        isLoggedIn = loginService.isLoggedIn
        signingUp = loginService.signingUp
        self.app = app
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
            
            
        })
    }
    
    func checkUsername(_ username:String) {
        self.checkingUsername = true
        debounce(seconds: 0.5) {
            self.app.usernameExists(username: username) { exists, error in
                guard error == nil else {
                    self.usernameFree = true
                    self.checkingUsername = false
                    return
                }
                DispatchQueue.main.async{
                    self.checkingUsername = false
                    self.usernameFree = !exists
                }
           }
            
        }
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
                self.signingUp = true
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
    
    func completeSignUp(name: String, username: String) {
        let client = app.realmApp.mongoClient("mongodb-atlas")
        let database = client.database(withName: "music")
        let collection = database.collection(withName: "users")
        collection.updateOneDocument(
            filter: ["user_id": AnyBSON(app.realmApp.currentUser()!.identity!)],
            update: ["$set": ["name": AnyBSON(name), "username":AnyBSON(username)]]
        ) { (updateResult, error) in
              guard error == nil else {
                  print("Failed to update: \(error!.localizedDescription)")
                  return
              }
            DispatchQueue.main.async {
                self.app.initialiseRealm()
            }
            
        }
    }
    
    func isValidEmail(_ email:String) -> Bool {
        return email.range(of: #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#, options: .regularExpression) != nil
        
    }
    
    
    
}
