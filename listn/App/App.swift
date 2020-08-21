//
//  App.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation
import RealmSwift

class ListnApp : ListnAppData {
    
    var realmApp : RealmApp!
    var loginService : LoginService!
    var user : User?
    var realm : Realm?
    var feedToken : NotificationToken?
    
    var isLoggedIn : Bool {
        get {
            return loginService.isLoggedIn
        }
    }
    
    init( completion: @escaping (Bool, ListnApp) -> Void) {
        // Init AppData
        super.init()
        
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
    
    func getUserReviews(completion: @escaping (Error?, (Array<ListnUserReview>?)) -> ()) {
        Network.shared.apollo.fetch(query:UserReviewsQuery(query: UserReviewQueryInput(userId:user!._id.stringValue))) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.userReviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ListnUserReview(apolloResult: review.fragments.userReviewDetail)})
                completion(nil, toReturn!)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
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

class ListnAppData : AppData, SearchData {
    func search(query: String, completion: @escaping (Error?, SearchResults?) -> ()) {
        Network.shared.apollo.fetch(query: SearchQuery(input: query)) { result in
            switch result {
            case .success(let graphQlResult):
                let albumIds = graphQlResult.data?.search?.albums?.compactMap({albumId in albumId!})
                let artistIds = graphQlResult.data?.search?.artists?.compactMap({artistId in artistId!})
                let reviewerIds = graphQlResult.data?.search?.reviewers?.compactMap({reviewerId in reviewerId!})
                self.getAlbums(albumIds: albumIds ?? []) { error, results in
                    guard error == nil else {
                        completion(error, nil)
                        return
                    }
                    let albums = results!
                    self.getArtists(artistIds: artistIds ?? []) {  error, results in
                        guard error == nil else {
                            completion(error, nil)
                            return
                        }
                        let artists = results!
                        self.getReviewers(reviewerIds: reviewerIds ?? []){ error, results in
                             guard error == nil else {
                                completion(error, nil)
                                return
                             }
                             let reviewers = results!
                            completion(nil, SearchResults(albums: albums, artists: artists, reviewers: reviewers))
                        }
                    }
                }
                //completion(nil, SearchResults(albums: albumIds!, artists: artistIds!, reviewers: reviewerIds!))
            case .failure(let error) :
                print(error)
                completion(error,nil)
            }
        }
    }
    
    func getReviewsForIDs(IDs: [String], completion: @escaping (Error?, Array<ListnReview>?) -> ()) {
        //Network.shared.apollo.fetch(query: ReviewsQuery(query: ReviewQueryInput(_idIn:IDs))) { result in
        Network.shared.apollo.fetch(query: ReviewsQuery(query: ReviewQueryInput(_idIn:IDs))) { result in
            switch result {
            case .success(let graphQlResult):
                /*let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let criticReviews = reviews?.compactMap({review in ListnCriticReview(apolloResult: review.fragments.reviewDetail)})*/
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let criticReviews = reviews?.compactMap({review in ListnCriticReview(apolloResult: review.fragments.reviewDetail)})
                Network.shared.apollo.fetch(query: UserReviewsQuery(query: UserReviewQueryInput(_idIn:IDs))) {result in
                    switch result {
                        case .success( let graphQlResult):
                        let reviews = graphQlResult.data?.userReviews.compactMap({review in review!})
                        let userReviews = reviews?.compactMap({review in ListnUserReview(apolloResult: review.fragments.userReviewDetail)})
                        var toReturn = Array<ListnReview>()
                        toReturn = userReviews! + criticReviews!
                        completion(nil, toReturn)
                    case.failure(let error):
                        print(error)
                        completion(error, nil)
                    }
                }
                
                //completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    
    func getAlbums(artistId: String, completion: @escaping (Error?, Array<ListnAlbum>?) -> Void) {
        print("FETCHING DATA")
        Network.shared.apollo.fetch(query: AlbumQuery(query: AlbumQueryInput(artist:ArtistQueryInput(_id: artistId)))) { result in
            switch result {
            case .success(let graphQlResult):
                let albums = graphQlResult.data?.albums.compactMap({albumResult in albumResult!})
                let toReturn = albums?.compactMap({album in ListnAlbum(apolloResult: album.fragments.albumDetail)})
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
        Network.shared.apollo.fetch(query: ReviewsQuery(query: ReviewQueryInput(artist: artistId))) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ListnCriticReview(apolloResult: review.fragments.reviewDetail)})
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
        Network.shared.apollo.fetch(query: ReviewsQuery(query: ReviewQueryInput(album: albumId))) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ListnCriticReview(apolloResult: review.fragments.reviewDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func getReviews(reviewerId: String, completion: @escaping (Error?, Array<ListnReview>?) -> ()) {
        Network.shared.apollo.fetch(query: ReviewsQuery(query: ReviewQueryInput(reviewer:reviewerId), limit: 20)) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ListnCriticReview(apolloResult: review.fragments.reviewDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    // Assumes that token is already added to Network class!
    func getLatestReviews(completion: @escaping (Error?, Array<ListnReview>?) -> ()) {
        Network.shared.apollo.fetch(query: LatestReviewsQuery()) { result in
            switch result {
            case .success(let graphQlResult):
                let reviews = graphQlResult.data?.reviews.compactMap({review in review!})
                let toReturn = reviews?.compactMap({review in ListnCriticReview(apolloResult: review.fragments.reviewDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func getAlbums(albumIds: [String], completion: @escaping (Error?, Array<ListnAlbum>?) -> ()) {
        Network.shared.apollo.fetch(query:AlbumQuery(query: AlbumQueryInput(_idIn:albumIds))) { result in
            switch result {
            case .success(let graphQlResult):
                let albums = graphQlResult.data?.albums.compactMap({albumResult in albumResult!})
                let toReturn = albums?.compactMap({album in ListnAlbum(apolloResult: album.fragments.albumDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
            }
        }
    }
    
    func getReviewers(reviewerIds:[String], completion: @escaping (Error?, Array<ListnReviewer>?) -> ()) {
        Network.shared.apollo.fetch(query:ReviewersQuery(query: ReviewerQueryInput(_idIn:reviewerIds))) { result in
            switch result {
            case .success(let graphQlResult):
                let reviewers = graphQlResult.data?.reviewers.compactMap({reviewerResult in reviewerResult!})
                let toReturn = reviewers?.compactMap({reviewer in ListnReviewer(apolloResult: reviewer.fragments.reviewerDetail)})
                completion(nil, toReturn!)
                //let albums = graphQlResult.data?.albums.map( return result! )
                //completion(nil, graphQlResult.data?.albums)
            case .failure(let error) :
                print(error)
                completion(error, nil)
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
                let toReturn = artists?.compactMap({artist in ListnArtist(apolloResult: artist.fragments.artistDetail)})
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
