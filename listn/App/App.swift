//
//  App.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation
import RealmSwift
import ApolloCombine
import Combine

class ListnApp : ObservableObject {
    
    var realmApp : RealmApp
    var loginService : LoginService!
    var user : User?
    var listnUser : ListnUser?
    var realm : Realm?
    var feedToken : NotificationToken?
    
    @Published var isLoading = true
    @Published var isLoggedIn = false
    @Published var loginError = false
    
    // MARK: ApolloCombine Publishers
    
    func searchPublisher(query:String ) -> AnyPublisher<SearchResults, URLError> {
        let searchResults = Network.shared.apollo.fetchPublisher(query: SearchQuery(input: query))
        .delay(for:0.5, scheduler: RunLoop.main)
        .retry(3)
        .compactMap { result in
            result.data?.search
        }
        .compactMap { search -> ([String], [String], [String]) in
            let albums = search.albums!.compactMap {$0!}
            let artists = search.artists!.compactMap {$0!}
            let reviewers = search.users!.compactMap {$0!}
            return (albums, artists, reviewers)
        }
        .compactMap { albums, artists, reviewers -> (ListnAlbumQuery, ListnArtistQuery, ListnUserQuery)  in
            let albumsQuery = ListnAlbumQuery(ids:albums)
            let artistsQuery = ListnArtistQuery(ids:artists)
            let usersQuery = ListnUserQuery(ids:reviewers)
            return (albumsQuery, artistsQuery, usersQuery)
        }.map { albumQuery, artistQuery, userQuery -> AnyPublisher<SearchResults, URLError> in
            let albums = self.albumPublisher(query: albumQuery).eraseToAnyPublisher()
            let artists = self.artistPublisher(query: artistQuery).eraseToAnyPublisher()
            let users = self.userPublisher(query:userQuery).eraseToAnyPublisher()
            //return Publishers.Sequence<[AnyPublisher<SearchResults, URLError>]>(sequence: [albums, artists, reviewers])
            
            return albums.combineLatest(artists, users)
            .compactMap { albumResults, artistResults, userResults in
                return SearchResults(albums: albumResults, artists: artistResults, users: userResults)
            }.mapError { error in
                return URLError(.notConnectedToInternet)
            }.eraseToAnyPublisher()
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        
        return searchResults.switchToLatest().eraseToAnyPublisher()
    }
        
    func albumPublisher(query:ListnAlbumQuery) -> AnyPublisher<[ListnAlbum], URLError> {
        let albumPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
        .retryWithDelay()
        .compactMap { result in
            result.data?.albums
        }
        .compactMap { albums in
            albums.compactMap { album in
                ListnAlbum(apolloResult: (album?.fragments.albumDetail)!)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return albumPublisher.eraseToAnyPublisher()
    
    }
    
    func userPublisher(query:ListnUserQuery) -> AnyPublisher<[ListnUser], URLError> {
        let reviewerPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
        .retryWithDelay()
        .compactMap { result in
            result.data?.users
        }
        .compactMap { user in
            user.compactMap { reviewer in
                ListnUser(apolloResult: (reviewer?.fragments.userDetail)!)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return reviewerPublisher.eraseToAnyPublisher()
    
    }
    
    func artistPublisher(query:ListnArtistQuery) -> AnyPublisher<[ListnArtist], URLError> {
        let artistPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
        .retryWithDelay()
        .compactMap { result in
            result.data?.artists
        }
        .compactMap { artists in
            artists.compactMap { artist in
                ListnArtist(apolloResult: (artist?.fragments.artistDetail)!)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return artistPublisher.eraseToAnyPublisher()
    
    }
    
    func reviewsPublisher(query:ListnReviewQuery, paginated: Bool = true) -> AnyPublisher<[ListnReview], URLError> {
        let reviewsPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
        .retryWithDelay()
        .compactMap { result in
            result.data?.reviews
        }
        .compactMap { reviews in
            reviews.compactMap { review in
                ListnReview(apolloResult: review!.fragments.reviewDetail)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return reviewsPublisher.eraseToAnyPublisher()
    }
    
    func paginatedReviewsPublisher(query:ListnReviewQuery, paginated: Bool = true) -> AnyPublisher<[ListnReview], URLError> {
        let reviewsPublisher = Network.shared.apollo.fetchPublisher(query: query.paginatedQuery())
        .retry(3)
        .retryWithDelay()
        .compactMap { result in
            result.data?.reviewPage
        }
        .compactMap { reviews in
            reviews.compactMap { review in
                ListnReview(apolloResult: review!.fragments.reviewDetail)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return reviewsPublisher.eraseToAnyPublisher()
    }
    
    
    func feedPublisher(ids:[String]) -> AnyPublisher<[ListnReview], URLError> {
        let publisher = Network.shared.apollo.fetchPublisher(query: ReviewsQuery(query:ReviewQueryInput(_idIn:ids)))
            .retry(3)
        .retryWithDelay()
        .compactMap { result in
            result.data?.reviews
        }
        .compactMap{ reviews in
            return reviews.compactMap { review in
                ListnReview(apolloResult: review!.fragments.reviewDetail) as ListnReview
            }
        }
        .mapError { error in
            return URLError(.notConnectedToInternet)
        }.eraseToAnyPublisher()
        
        return publisher.eraseToAnyPublisher()
    }
    
    // MARK: Query type definitions
    
    struct ListnAlbumQuery {
        var id : String?
        var ids : [String]?
        var artist : String?
        
        func query() -> AlbumQuery {
            let artistQuery = (artist != nil) ? ArtistQueryInput(_id: artist) : nil
            return AlbumQuery(query: AlbumQueryInput(_id: id, artist: artistQuery, _idIn: ids))
        }
    }
    
    struct ListnReviewQuery {
        var id : String?
        var ids : [String]?
        var artist : String?
        var album : String?
        var reviewer : String?
        var paginated : Bool = false
        var user : String?
        var last : String?
        
        func query() -> ReviewsQuery {
            return ReviewsQuery(query: ReviewQueryInput(artist: artist, _id: id, _idIn: ids, user:user, album:album))
        }
        
        func paginatedQuery() -> ReviewPageQuery {
            return ReviewPageQuery(input: ReviewPageInput(user: user, last: last, album: album, artist: artist))
        }
    }
    
    struct ListnUserQuery {
        var id : String?
        var ids : [String]?
        
        func query() -> UsersQuery {
            return UsersQuery(query: UserQueryInput(_idIn: ids, _id: id))
        }
    }
    
    struct ListnArtistQuery {
        var id : String?
        var ids : [String]?
        
        func query() -> ArtistQuery {
            return ArtistQuery(query:ArtistQueryInput(_idIn: ids, _id: id))
        }
    }
    
    // MARK: Async initialiser
    
    init() {
        
        // Initialise Realm App
        let config = AppConfiguration(baseURL: "https://realm.mongodb.com", transport: nil, localAppName: nil, localAppVersion: nil)
        realmApp = RealmApp(id:"listn-bsliv", configuration: config)
        
        // Initialise login service and fill variables if logged in
        loginService = MongoLoginService(app: realmApp)
        if loginService.isLoggedIn {
            Network.shared.tokenManger = GraphQLTokenManager()
            self.realm = try! Realm(configuration: self.realmApp.currentUser()!.configuration(partitionValue:(self.realmApp.currentUser()?.identity)!))
            
            let user = realm?.objects(User.self).first
            let feed = realm?.objects(UserFeed.self).first
            
            guard user != nil && feed != nil else {
                Realm.asyncOpen(configuration: self.realmApp.currentUser()!.configuration(partitionValue:(self.realmApp.currentUser()?.identity)!), callbackQueue: DispatchQueue.main) { realm, error in
                    guard realm != nil else {
                        self.loginError = true
                        return
                    }
                    self.realm = realm!
                    let user = realm!.objects(User.self).first!
                    self.user = user
                    self.listnUser = ListnUser(user: user)
                    self.isLoggedIn = true
                    self.isLoading = false
                }
                return
            }
            self.user = user!
            self.listnUser = ListnUser(user : user!)
            self.isLoading = false
            self.isLoggedIn = true
            
        }
        else {
            self.isLoggedIn = false
            self.isLoading = false
        }
        
    }
    
    
    // MARK: Realm functions (posting reviews, etc.)
    
    func refreshUserFeed(completion: @escaping(Array<String>) -> Void) {
        realmApp.functions.updateUserFeed([AnyBSON(user!._id!)!]) { result, error in
            print("feed updated")
            DispatchQueue.main.async {
                self.realm!.refresh()
                self.getUserFeed(completion: completion)
            }
        }
    }
    
    func getUserFeed( completion: @escaping (Array<String>) -> Void ) {
        let feeds = realm!.objects(UserFeed.self)
        guard feeds.count != 0 else {
            completion([])
            return
        }
        let userFeed = feeds[0]
        /*feedToken = feeds.observe() { updatedChanges in
            switch updatedChanges {
            case .update(let feeds, _, _, _):
                let userFeed = feeds[0]
                let feed = userFeed.reviews
                let reviewIds = Array(feed).compactMap({review in return review.id!})
                completion(reviewIds)
                return
            case .error(_):
                return
            case .initial(let feeds):
                let userFeed = feeds[0]
                let feed = userFeed.reviews
                let reviewIds = Array(feed).compactMap({review in return review.id!})
                completion(reviewIds)
                return
            }
            
        }*/
        let feed = userFeed.reviews
        let reviewIds = Array(feed).compactMap({review in return review.id!})
        completion(reviewIds)
    }
    func postReview(review:ListnReview) {
        let userReview = Review(listnReview: review, partitionKey: realmApp.currentUser()!.identity!)
        
        do {
            try realm!.write {
                realm!.add(userReview)
            }
        }
        catch {
            print(error)
        }
    }
    
    func toggleFollow(userId: String) {
        let follow = findFollow(userId: userId)
        guard follow != nil else {
            let follow = UserFollow()
            follow._partitionKey = realmApp.currentUser()!.identity!
            follow.userFollowed = try! ObjectId(string: userId)
            print(follow.userFollowed!)
            follow.user = user?._id!
            
            try! realm!.write {
                realm!.add(follow)
            }
            return
        }
        try! realm!.write{
            realm!.delete(follow!)
        }
    }
    
    func findFollow(userId :String) -> UserFollow? {
        let follows = realm!.objects(UserFollow.self)
        let predicate = NSPredicate(format: "userFollowed == %@", try! ObjectId(string:userId))
        let matchingFollows = follows.filter(predicate)
        if matchingFollows.count > 0 {
            return matchingFollows[0]
        }
        else {
            return nil
        }
    }
    
    func findLike(reviewId: String) -> ReviewLike? {
        let likes = realm!.objects(ReviewLike.self)
        let predicate = NSPredicate(format: "reviewLiked == %@", try! ObjectId(string:reviewId))
        let matchingLikes = likes.filter(predicate)
        return matchingLikes.first
    }
    
    func isLiked(_ reviewId: String) -> Bool {
        return (findLike(reviewId: reviewId) != nil)
    }
    
    func toggleLike(reviewId: String) {
        let like = findLike(reviewId: reviewId)
        guard like != nil else {
            let like = ReviewLike()
            like._partitionKey = realmApp.currentUser()!.identity!
            like.reviewLiked = try! ObjectId(string: reviewId)
            like.user = user?._id!
            
            try! realm!.write {
                realm!.add(like)
            }
            return
        }
        try! realm!.write{
            realm!.delete(like!)
        }
    }
        
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

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


extension Publisher {
  func retryWithDelay<T, E>()
    -> Combine.Publishers.Catch<Self, AnyPublisher<T, E>> where T == Self.Output, E == Self.Failure
  {
    return self.catch { error -> AnyPublisher<T, E> in
      return Publishers.Delay(
        upstream: self,
        interval: 1,
        tolerance: 1,
        scheduler: DispatchQueue.global()).retry(2).eraseToAnyPublisher()
    }
  }
}
