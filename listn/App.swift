//
//  App.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation
import RealmSwift

class ListnApp {
    
    var realmApp : RealmApp!
    var loginService : LoginService!
    var user : User?
    var realm : Realm?
    var appData : AppData?
    
    var isLoggedIn : Bool {
        get {
            return loginService.isLoggedIn
        }
    }
    
    init() {
        // Initialise Realm App
        let config = AppConfiguration(baseURL: "https://realm.mongodb.com", transport: nil, localAppName: nil, localAppVersion: nil)
        realmApp = RealmApp(id:"listn-bsliv", configuration: config)
        
        // Initialise login service and fill variables if logged in
        loginService = MongoLoginService(app: realmApp)
        if loginService.isLoggedIn {
            realm = try! Realm(configuration: app.currentUser()!.configuration(partitionValue:(app.currentUser()?.identity)!))
            Network.shared.token = app.currentUser()!.accessToken!
            user = realm?.objects(User.self)[0]
        }
        
    }
    
    
    
    
    
    
    
}

class ListnAppData : AppData {
    // Assumes that token is already added to Network class!
    
    func getLatestReviews() -> Array<Review> {
        return []
    }
    
    func getAlbums(artist: Artist) -> Array<Album> {
        /*Network.shared.token = (app.currentUser()?.accessToken!)!
        print(Network.shared.token)
        Network.shared.apollo.fetch(query: AlbumQuery(query:AlbumQueryInput(name:"Punisher"))) { result in
            switch result {
            case .success(let graphQlResult):
                print("success! Result:\(graphQlResult.data?.album?.artist?.name)")
            case .failure(let error) :
                print(error)
            }
            
            
        }*/
        /*
        Network.shared.apollo.fetch(query: AlbumQuery(query: AlbumQueryInput(artist:ArtistQueryInput(_id: artist._id!.stringValue)))) { result in
            switch result {
            case .success(let graphQlResult):
                return graphQlResult.data?.albums
            case .failure(let error) :
                print(error)
                return []
            }
        }*/
        
        return []
    }
    
    func getReviews(artist: Artist) -> Array<Review> {
        return []
    }
    
    func getReviews(album: Album) -> Array<Review> {
        return []
    }
    
    func getReviews(user: User) -> Array<Review> {
        return []
    }
    
    
}

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
        
        // Check if User is looged in (THIS CODE NEEDS TO BE FIXED!!
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
