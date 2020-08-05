//
//  AppProtocol.swift
//  listn
//
//  Created by Pierre Rodgers on 4/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation

protocol LoginService {
    func signUp(username:String, password:String, completion:@escaping (Error?) -> Void)
    
    func logIn(username:String, password:String, completion:@escaping (Error?) -> Void)
    
    var isLoggedIn : Bool { get }
    
    func logOut(completion: @escaping (Error?) -> Void)
    
}

protocol AppData : ArtistData, AlbumData, UserData, SearchData {
    func getLatestReviews(completion: @escaping (Error?, Array<ListnReview>?) -> ())
    
    func getReviewsForIDs(IDs:[String], completion: @escaping (Error?, Array<ListnReview>?) -> ())
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