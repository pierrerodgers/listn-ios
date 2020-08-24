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

class ListnApp  {
    
    var realmApp : RealmApp!
    var loginService : LoginService!
    var user : User?
    var realm : Realm?
    var feedToken : NotificationToken?
    
    // MARK: Testing for ApolloCombine
    
    
    
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
            let reviewers = search.reviewers!.compactMap {$0!}
            return (albums, artists, reviewers)
        }
        .compactMap { albums, artists, reviewers -> (ListnAlbumQuery, ListnArtistQuery, ListnReviewerQuery)  in
            let albumsQuery = ListnAlbumQuery(ids:albums)
            let artistsQuery = ListnArtistQuery(ids:artists)
            let reviewersQuery = ListnReviewerQuery(ids:reviewers)
            return (albumsQuery, artistsQuery, reviewersQuery)
        }.map { albumQuery, artistQuery, reviewerQuery -> AnyPublisher<SearchResults, URLError> in
            let albums = self.albumPublisher(query: albumQuery).eraseToAnyPublisher()
            let artists = self.artistPublisher(query: artistQuery).eraseToAnyPublisher()
            let reviewers = self.reviewerPublisher(query:reviewerQuery).eraseToAnyPublisher()
            //return Publishers.Sequence<[AnyPublisher<SearchResults, URLError>]>(sequence: [albums, artists, reviewers])
            
            return albums.combineLatest(artists, reviewers)
            .compactMap { albumResults, artistResults, reviewerResults in
                return SearchResults(albums: albumResults, artists: artistResults, reviewers: reviewerResults)
            }.mapError { error in
                return URLError(.notConnectedToInternet)
            }.eraseToAnyPublisher()
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        
        return searchResults.switchToLatest().eraseToAnyPublisher()
    }
    
    struct ListnAlbumQuery {
        var id : String?
        var ids : [String]?
        var artist : String?
        
        func query() -> AlbumQuery {
            let artistQuery = (artist != nil) ? ArtistQueryInput(_id: artist) : nil
            return AlbumQuery(query: AlbumQueryInput(_idIn: ids, artist: artistQuery, _id: id))
        }
    }
    
    struct ListnReviewQuery {
        var id : String?
        var ids : [String]?
        var artist : String?
        var album : String?
        var reviewer : String?
        var paginated : Bool = false
        var last : String?
        
        func query() -> ReviewsQuery {
            return ReviewsQuery(query: ReviewQueryInput(artist: artist, _id: id,reviewer:reviewer, album:album, _idIn: ids))
        }
        
        func paginatedQuery() -> ReviewPageQuery {
            return ReviewPageQuery(input: ReviewPageInput(album: album, artist: artist, reviewer: reviewer, user: nil, last: last))
        }
    }
    
    struct ListnReviewerQuery {
        var id : String?
        var ids : [String]?
        
        func query() -> ReviewersQuery {
            return ReviewersQuery(query: ReviewerQueryInput(_id: id, _idIn: ids))
        }
    }
    
    struct ListnArtistQuery {
        var id : String?
        var ids : [String]?
        
        func query() -> ArtistQuery {
            return ArtistQuery(query:ArtistQueryInput(_idIn: ids, _id: id))
        }
    }
    
    struct ListnUserReviewQuery {
        var id : String?
        var user : String?
        var ids : [String]?
        var artist : String?
        var album : String?
        
        func query() -> UserReviewsQuery {
            return UserReviewsQuery(query:UserReviewQueryInput(_idIn: ids, albumId:album, _id: id, userId: user))
        }
    }
    
    
    func albumPublisher(query:ListnAlbumQuery) -> AnyPublisher<[ListnAlbum], URLError> {
        let albumPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
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
    
    func reviewerPublisher(query:ListnReviewerQuery) -> AnyPublisher<[ListnReviewer], URLError> {
        let reviewerPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
        .compactMap { result in
            result.data?.reviewers
        }
        .compactMap { reviewers in
            reviewers.compactMap { reviewer in
                ListnReviewer(apolloResult: (reviewer?.fragments.reviewerDetail)!)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return reviewerPublisher.eraseToAnyPublisher()
    
    }
    
    func artistPublisher(query:ListnArtistQuery) -> AnyPublisher<[ListnArtist], URLError> {
        let artistPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
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
    
    func reviewsPublisher(query:ListnReviewQuery, paginated: Bool = true) -> AnyPublisher<[ListnCriticReview], URLError> {
        let reviewsPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
        .compactMap { result in
            result.data?.reviews
        }
        .compactMap { reviews in
            reviews.compactMap { review in
                ListnCriticReview(apolloResult: review!.fragments.reviewDetail)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return reviewsPublisher.eraseToAnyPublisher()
    }
    
    func paginatedReviewsPublisher(query:ListnReviewQuery, paginated: Bool = true) -> AnyPublisher<[ListnCriticReview], URLError> {
        let reviewsPublisher = Network.shared.apollo.fetchPublisher(query: query.paginatedQuery())
        .retry(3)
        .compactMap { result in
            result.data?.reviewPage
        }
        .compactMap { reviews in
            reviews.compactMap { review in
                ListnCriticReview(apolloResult: review!.fragments.reviewDetail)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return reviewsPublisher.eraseToAnyPublisher()
    }
    
    
    func userReviewsPublisher(query:ListnUserReviewQuery) -> AnyPublisher<[ListnUserReview], URLError> {
        let reviewsPublisher = Network.shared.apollo.fetchPublisher(query: query.query())
        .retry(3)
        .compactMap { result in
            result.data?.userReviews
        }
        .compactMap { reviews in
            reviews.compactMap { review in
                ListnUserReview(apolloResult: review!.fragments.userReviewDetail)
            }
        }.mapError { error in
            return URLError(.notConnectedToInternet)
        }
        
        return reviewsPublisher.eraseToAnyPublisher()
    }
    
    func feedPublisher(ids:[String]) -> AnyPublisher<[ListnReview], URLError> {
        let criticReviewPublisher = Network.shared.apollo.fetchPublisher(query: ReviewsQuery(query:ReviewQueryInput(_idIn:ids)))
        .retry(3)
        .compactMap { result in
            result.data?.reviews
        }
        .compactMap{ reviews in
            return reviews.compactMap { review in
                ListnCriticReview(apolloResult: review!.fragments.reviewDetail) as ListnReview
            }
        }
        .mapError { error in
            return URLError(.notConnectedToInternet)
        }.eraseToAnyPublisher()
        
        let userReviewPublisher = Network.shared.apollo.fetchPublisher(query:UserReviewsQuery(query: UserReviewQueryInput(_idIn:ids)))
        .retry(3)
        .compactMap { result in
            return result.data?.userReviews
        }
        .compactMap { reviews in
            reviews.compactMap { review in
                ListnUserReview(apolloResult: (review?.fragments.userReviewDetail)!) as ListnReview
            }
        }
        .mapError { error in
            return URLError(.notConnectedToInternet)
        }.eraseToAnyPublisher()
        
        let publisher = criticReviewPublisher.combineLatest(userReviewPublisher)
        .compactMap{ criticReviews, userReviews -> [ListnReview] in
            var reviews = criticReviews +  userReviews
            
            reviews = reviews.sorted { $0.date > $1.date }
            return reviews
        }

        return publisher.eraseToAnyPublisher()
    }
    
    
    
    
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
                Network.shared.tokenManger = GraphQLTokenManager()
                Realm.asyncOpen(configuration: self.realmApp.currentUser()!.configuration(partitionValue:(self.realmApp.currentUser()?.identity)!), callbackQueue: DispatchQueue.main) { realm, error in
                    guard realm != nil else {
                        completion(false, self)
                        return
                    }
                    self.realm = realm!
                    let user = realm!.objects(User.self).first!
                    self.user = user
                    completion(true, self)
                }
                
            })
        }
        else {
            completion(false, self)
        }
        
    }
    
    func refreshUserFeed(completion: @escaping(Array<String>) -> Void) {
        realmApp.functions.updateUserFeed([AnyBSON(user!._id)!]) { result, error in
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
    func postReview(review:ListnUserReview) {
        let userReview = UserReview(listnUserReview: review, partitionKey: realmApp.currentUser()!.identity!, user: user!)
        
        do {
            try realm!.write {
                realm!.add(userReview)
            }
        }
        catch {
            print(error)
        }
    }
    
    func toggleFollow(reviewerId: String) {
        let follow = findFollow(reviewerId: reviewerId)
        guard follow != nil else {
            let follow = ReviewerFollow()
            follow._partitionKey = realmApp.currentUser()!.identity!
            follow.reviewerFollowed_id = try! ObjectId(string: reviewerId)
            follow.user = user!
            
            try! realm!.write {
                realm!.add(follow)
            }
            return
        }
        try! realm!.write{
            realm!.delete(follow!)
        }
    }
    
    func findFollow(reviewerId:String) -> ReviewerFollow? {
        let follows = realm!.objects(ReviewerFollow.self)
        let predicate = NSPredicate(format: "reviewerFollowed_id == %@", try! ObjectId(string:reviewerId))
        let matchingFollows = follows.filter(predicate)
        if matchingFollows.count > 0 {
            return matchingFollows[0]
        }
        else {
            return nil
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
