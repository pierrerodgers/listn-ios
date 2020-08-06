//
//  ListnDataModels.swift
//  listn
//
//  Created by Pierre Rodgers on 28/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation


struct ListnAlbum {
    
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
        artist = ListnArtist(apolloResult: apolloResult.artist!.fragments.artistDetail)
        
        // Initialise streamingUrls
        streamingUrls = ListnStreamingUrls(appleMusic: apolloResult.streamingUrls?.appleMusic ?? "", spotify: apolloResult.streamingUrls?.spotify ?? "")
    }
    
    var _id : String
    var name : String
    var artwork : String?
    var releaseDate : Date?
    var genres : [String]?
    var streamingUrls : ListnStreamingUrls
    var artist : ListnArtist
}

struct ListnArtist {
    init(apolloResult: ArtistDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        image = apolloResult.image ?? ""
        streamingUrls = ListnStreamingUrls(appleMusic: apolloResult.streamingUrls?.appleMusic ?? "", spotify: apolloResult.streamingUrls?.spotify ?? "")
    }
    
    var _id : String
    var name : String
    var image : String
    var streamingUrls : ListnStreamingUrls
}

struct ListnStreamingUrls {
    var appleMusic : String
    var spotify : String
}

struct ListnReview {
    init(apolloResult: ReviewDetail) {
        _id = apolloResult._id!
        score = apolloResult.score!
        link = apolloResult.link!
        
        // Initialise date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        date = dateFormatter.date(from: apolloResult.date ?? "") ?? Date()
        
        album = ListnAlbum(apolloResult: apolloResult.album!.fragments.albumDetail)
        
        reviewer = ListnReviewer(apolloResult: apolloResult.reviewer!)
        
    }
    var _id : String?
    var reviewer : ListnReviewer
    var album : ListnAlbum
    var link : String
    var score : String
    var date : Date
}

struct ListnReviewer {
    init(apolloResult: ReviewDetail.Reviewer) {
        _id = apolloResult._id!
        name = apolloResult.name!
        link = apolloResult.link!
    }
    
    var _id : String
    var name : String
    var link : String
}

struct ListnUserReview {
    var album : ListnAlbum
    var score : String
    var date : Date
    var text : String?
}
