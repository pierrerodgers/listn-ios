//
//  LoginViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import RealmSwift
import Combine

class LoginViewModel: ObservableObject {
    @Published var error : String?
    @Published var isAuthenticated : Bool = false
    @Published var isLoggedIn : Bool = false
    @Published var usernameFree : Bool = true
    @Published var checkingUsername : Bool = true
    
    @Published var isLoading : Bool = false
    
    let loginService : MongoLoginService
    let app : ListnApp
    
    private var timer : Timer?
    //private var subscribers : Set<AnyCancellable> = []
    
    private func debounce(seconds: TimeInterval, function: @escaping () -> Swift.Void ) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            function()
        })
    }
    
    
    init(loginService:MongoLoginService, app: ListnApp) {
        self.loginService = loginService
        isAuthenticated = loginService.isAuthenticated
        isLoggedIn = loginService.isLoggedIn
        self.app = app
        
        /*$isLoggedIn.sink { newValue in
            if newValue == true {
                self.app.isLoggedIn = true
            }
        }.store(in: &subscribers)
        
        $isLoggedIn.sink(receiveValue: {value in
            self.app.isLoggedIn = value
        }).store(in: &subscribers)*/
    }
    
    func logIn(email:String, password:String) {
        self.error = nil
        self.isLoading = true
        loginService.logIn(email: email, password: password, completion: {isAuthenticated, isLoggedIn, error in
            self.isLoading = false
            guard error == nil else {
                DispatchQueue.main.async {
                    self.error = error!.localizedDescription
                }
                return
            }
            DispatchQueue.main.async {
                self.isLoggedIn = isLoggedIn
                self.isAuthenticated = isAuthenticated
                self.app.isLoggedIn = isLoggedIn

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
    
    func signUp(email:String, password:String) {
        self.error = nil
        self.isLoading = true
        loginService.signUp(email: email, password: password) { isAuthenticated, isLoggedIn, error in
            self.isLoading = false
            guard error == nil else {
                DispatchQueue.main.async {
                    self.error = error!.localizedDescription
                }
                return
            }
            DispatchQueue.main.async {
                self.isAuthenticated = isAuthenticated
                self.isLoggedIn = isLoggedIn
                self.app.isLoggedIn = isLoggedIn
            }
            
            
        }
    }
    
    func logOut() {
        loginService.logOut(completion: { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.isLoggedIn = false
                self.app.isLoggedIn = false

            }
            
            
        })
    }
    
    func completeSignUp(name: String, username: String) {
        self.error = nil
        self.isLoading = true
        loginService.completeSignUp(username: username, name: name) { isAuthenticated, isLoggedIn, error in
            self.isLoading = false
            guard error == nil else {
                self.error = error!.localizedDescription
                return
            }
            
            
            self.isAuthenticated = isAuthenticated
            self.isLoggedIn = isLoggedIn
            self.app.isLoggedIn = isLoggedIn

            
        }
    }
    
    func isValidEmail(_ email:String) -> Bool {
        return email.range(of: #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#, options: .regularExpression) != nil
        
    }
    
    
    
}
