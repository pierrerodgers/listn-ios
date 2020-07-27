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
    
    var isLoggedIn : Bool { get }
    
    func logOut(completion: @escaping (Error?) -> Void)
    
}

protocol AppData : ArtistData, AlbumData, UserData {
    func getLatestReviews() -> Array<Review>
}

protocol ArtistData {
    func getAlbums(artist: Artist) -> Array<Album>
    
    func getReviews(artist:Artist) -> Array<Review>
    
}

protocol AlbumData {
    func getReviews(album: Album) -> Array<Review>
}

protocol UserData {
    func getReviews(user: User) -> Array<Review>
    
}

class MongoLoginService : LoginService {
    
    // We assume that app is intitialised
    private var app : RealmApp
    
    var isLoggedIn: Bool
    
    
    init(app:RealmApp) {
        self.app = app
        if (app.currentUser() != nil) {
            isLoggedIn = true
        }
        else {
            isLoggedIn = false
        }
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
        let credentials = AppCredentials(username: username, password: password)
        print(credentials)
        app.login(withCredential:AppCredentials(username: username, password: password), completion: {user, error in
            completion(error)
        })
    }
    
    func logOut(completion: @escaping (Error?) -> Void) {
        app.logOut(completion: completion)
    }
}
