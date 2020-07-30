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
    var realm : Realm? {
        get {
            try! Realm(configuration: realmApp.currentUser()!.configuration(partitionValue:(realmApp.currentUser()?.identity)!))
        }
    }
    var appData : AppData?
    
    var isLoggedIn : Bool {
        get {
            return loginService.isLoggedIn
        }
    }
    
    init( completion: @escaping (Bool, ListnApp) -> Void) {
        // Initialise Realm App
        let config = AppConfiguration(baseURL: "https://realm.mongodb.com", transport: nil, localAppName: nil, localAppVersion: nil)
        realmApp = RealmApp(id:"listn-bsliv", configuration: config)
        
        // Initialise login service and fill variables if logged in
        loginService = MongoLoginService(app: realmApp)
        if loginService.isLoggedIn {
            realmApp.currentUser()?.refreshCustomData({(error) in
                guard error == nil else {
                    self.loginService.logOut(completion: {error in
                        completion(false, self)
                    })
                    return
                }
                completion(true, self)
            })
            Network.shared.app = realmApp
            appData = ListnAppData()
        }
        else {
            completion(false, self)
        }
        
    }
    
    
    
    
    
    
    
}

class ListnAppData : AppData, SearchData {
    
    func getAlbums(artistId: String, completion: @escaping (Error?, Array<ListnAlbum>?) -> Void) {
        print("FETCHING DATA")
        Network.shared.apollo.fetch(query: AlbumQuery(query: AlbumQueryInput(artist:ArtistQueryInput(_id: artistId)))) { result in
            switch result {
            case .success(let graphQlResult):
                let albums = graphQlResult.data?.albums.compactMap({albumResult in albumResult!})
                let toReturn = albums?.compactMap({album in ApolloAlbum(apolloResult: album.fragments.albumDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func getReviews(artistId: String, completion: @escaping (Error?, Array<ListnReview>?) -> ()) {
        Network.shared.apollo.fetch(query: ReviewsQuery(query: ReviewQueryInput(artist:ArtistQueryInput(_id: artistId)))) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ApolloReview(apolloResult: review.fragments.reviewDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func getReviews(albumId: String, completion: @escaping (Error?, Array<ListnReview>?) -> ()) {
        Network.shared.apollo.fetch(query: ReviewsQuery(query: ReviewQueryInput(album:AlbumQueryInput(_id: albumId)))) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ApolloReview(apolloResult: review.fragments.reviewDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func getReviews(userId: String, completion: @escaping (Error?, Array<ListnReview>?) -> ()) {
         completion(nil, nil)
    }
    
    // Assumes that token is already added to Network class!
    func getLatestReviews(completion: @escaping (Error?, Array<ListnReview>?) -> ()) {
        Network.shared.apollo.fetch(query: LatestReviewsQuery()) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ApolloReview(apolloResult: review.fragments.reviewDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func searchAlbums(query: String, completion: @escaping (Error?, Array<String>?) -> ()) {
        Network.shared.apollo.fetch(query: AlbumSearchQuery(input: query)) { result in
            switch result {
            case .success(let graphQlResult):
                let ids = graphQlResult.data?.albumSearch?.albums?.compactMap({albumId in albumId!})
                completion(nil, ids!)
            case .failure(let error) :
                print(error)
                completion(error,nil)
            }
        }
    }
    
    func getAlbums(albumIds: [String], completion: @escaping (Error?, Array<ListnAlbum>?) -> ()) {
        Network.shared.apollo.fetch(query:AlbumQuery(query: AlbumQueryInput(_idIn:albumIds))) { result in
            switch result {
            case .success(let graphQlResult):
                let albums = graphQlResult.data?.albums.compactMap({albumResult in albumResult!})
                let toReturn = albums?.compactMap({album in ApolloAlbum(apolloResult: album.fragments.albumDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func searchArtists(query: String, completion: @escaping (Error?, Array<String>?) -> ()) {
        Network.shared.apollo.fetch(query: ArtistSearchQuery(input: query)) { result in
            switch result {
            case .success(let graphQlResult):
                let ids = graphQlResult.data?.artistSearch?.artists?.compactMap({artistId in artistId!})
                completion(nil, ids!)
            case .failure(let error) :
                print(error)
                completion(error,nil)
            }
        }
    }
    
    func searchReviewers(query: String, completion: @escaping (Error?, Array<String>?) -> ()) {
        completion(nil, nil)
    }
    
    func getArtists(artistIds: [String], completion: @escaping (Error?, Array<ListnArtist>?) -> ()) {
        Network.shared.apollo.fetch(query:ArtistQuery(query: ArtistQueryInput(_idIn:artistIds))) { result in
            switch result {
            case .success(let graphQlResult):
                let artists = graphQlResult.data?.artists.compactMap({artistResult in artistResult!})
                let toReturn = artists?.compactMap({artist in ApolloArtist(apolloResult: artist.fragments.artistDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
}

protocol LoginService {
    func signUp(username:String, password:String, completion:@escaping (Error?) -> Void)
    
    func logIn(username:String, password:String, completion:@escaping (Error?) -> Void)
    
    var isLoggedIn : Bool { get }
    
    func logOut(completion: @escaping (Error?) -> Void)
    
}

protocol AppData : ArtistData, AlbumData, UserData, SearchData {
    func getLatestReviews(completion: @escaping (Error?, Array<ListnReview>?) -> ())
}

protocol ArtistData {
    func getAlbums(artistId: String, completion: @escaping (Error?, Array<ListnAlbum>?) -> Void)
    
    func getReviews(artistId:String, completion: @escaping (Error?, Array<ListnReview>?) -> ())
    
    func getArtists(artistIds: [String], completion: @escaping (Error?, Array<ListnArtist>?) -> ())
    
}

protocol AlbumData {
    func getReviews(albumId: String, completion: @escaping (Error?, Array<ListnReview>?) -> ())
    
    func getAlbums(albumIds: [String], completion: @escaping (Error?, Array<ListnAlbum>?) -> ())
}

protocol UserData {
    func getReviews(userId: String, completion: @escaping (Error?, Array<ListnReview>?) -> ())
    
}

protocol SearchData {
    func searchAlbums(query:String, completion: @escaping (Error?, Array<String>?) -> ())
    func searchArtists(query:String, completion: @escaping (Error?, Array<String>?) -> ())
    func searchReviewers(query:String, completion: @escaping (Error?, Array<String>?) -> ())
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
