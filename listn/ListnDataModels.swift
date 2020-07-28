//
//  ListnDataModels.swift
//  listn
//
//  Created by Pierre Rodgers on 28/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation


protocol ListnAlbum {
    var _id : String { get }
    var name : String { get }
    var artwork : String? { get }
    var releaseDate : Date? { get }
    var genres : [String]? { get }
    var streamingUrls : ListnStreamingUrls { get }
    var artist : ListnArtist { get }
}

protocol ListnArtist {
    var _id : String { get }
    var name : String { get }
    var image : String { get }
    var streamingUrls : ListnStreamingUrls { get }
}

protocol ListnStreamingUrls {
    var appleMusic : String { get }
    var spotify : String { get }
}

protocol ListnReview {
    var _id : String { get }
    var reviewer : ListnReviewer { get }
    var album : ListnAlbum { get }
    var link : String { get }
    var score : String { get }
    var date : Date { get }
}

protocol ListnReviewer {
    var _id : String { get }
    var name : String { get }
    var link : String { get }
}

struct ApolloAlbum : ListnAlbum {
    
    init(apolloResult: AlbumQuery.Data.Album) {
        // Initialise all strings
        _id = apolloResult._id!
        name = apolloResult.name!
        artwork = apolloResult.artwork ?? ""
        genres = apolloResult.genres?.compactMap({string in string!}) ?? []
        
        // Initialise date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        releaseDate = dateFormatter.date(from: apolloResult.releaseDate ?? "")
        
        // Initialise Artist
        artist = ApolloArtist(apolloResult: apolloResult.artist!)
        
        // Initialise streamingUrls
        streamingUrls = StreamingUrls(spotify: apolloResult.streamingUrls!.spotify!, appleMusic: apolloResult.streamingUrls!.appleMusic!)
    }
    
    var streamingUrls: ListnStreamingUrls
    
    var artist: ListnArtist
    
    var _id: String
    
    var name: String
    
    var artwork: String?
    
    var releaseDate: Date?
    
    var genres: [String]?
    
}

struct ApolloArtist : ListnArtist {
    var _id: String
    
    var name: String
    
    var image: String
    
    var streamingUrls: ListnStreamingUrls
    
    init(apolloResult: AlbumQuery.Data.Album.Artist) {
        _id = apolloResult._id!
        name = apolloResult.name!
        image = apolloResult.image ?? ""
        streamingUrls = StreamingUrls(spotify: apolloResult.streamingUrls!.spotify!, appleMusic: apolloResult.streamingUrls!.appleMusic!)
    }
}

struct StreamingUrls : ListnStreamingUrls {
    var spotify: String
    var appleMusic: String
    
}
