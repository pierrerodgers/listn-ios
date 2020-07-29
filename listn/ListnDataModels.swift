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
    
    
    init(apolloResult: AlbumDetail) {
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
        artist = ApolloArtist(apolloResult: apolloResult.artist!.fragments.artistDetail)
        
        // Initialise streamingUrls
        streamingUrls = StreamingUrls(spotify: apolloResult.streamingUrls?.spotify ?? "", appleMusic: apolloResult.streamingUrls?.appleMusic ?? "")
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
    
    init(apolloResult: ArtistDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        image = apolloResult.image ?? ""
        streamingUrls = StreamingUrls(spotify: apolloResult.streamingUrls?.spotify ?? "", appleMusic: apolloResult.streamingUrls?.appleMusic ?? "")
    }
    
}

struct ApolloReview : ListnReview {
    init(apolloResult: ReviewDetail) {
        _id = apolloResult._id!
        score = apolloResult.score!
        link = apolloResult.link!
        
        // Initialise date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        date = dateFormatter.date(from: apolloResult.date ?? "") ?? Date()
        
        album = ApolloAlbum(apolloResult: apolloResult.album!.fragments.albumDetail)
        
        reviewer = ApolloReviewer(apolloResult: apolloResult.reviewer!)
        
    }
    
    var _id: String
    
    var reviewer: ListnReviewer
    
    var album: ListnAlbum
    
    var link: String
    
    var score: String
    
    var date: Date
}

struct ApolloReviewer : ListnReviewer {
    init(apolloResult: ReviewDetail.Reviewer) {
        _id = apolloResult._id!
        name = apolloResult.name!
        link = apolloResult.link!
    }
    
    var _id: String = ""
    
    var name: String = ""
    
    var link: String = ""
    
    
    
}


struct StreamingUrls : ListnStreamingUrls {
    var spotify: String
    var appleMusic: String
    
}
