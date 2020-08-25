//
//  ListnDataModels.swift
//  listn
//
//  Created by Pierre Rodgers on 28/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation

func dateFromMongoDB(_ mongoDbString:String) -> Date {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [
        .withFullDate,
        .withFullTime,
        .withDashSeparatorInDate]
    let date = formatter.date(from: mongoDbString)
    guard let fullDate = date else {
        formatter.formatOptions = [
        .withFullDate,
        .withFullTime,
        .withDashSeparatorInDate,
        .withFractionalSeconds]
        return formatter.date(from: mongoDbString) ?? Date()
    }
    return fullDate
}

struct ListnAlbum {
    init(apolloResult: AlbumDetail) {
        // Initialise all strings
        _id = apolloResult._id!
        name = apolloResult.name!
        artwork = apolloResult.artwork ?? ""
        genres = apolloResult.genres?.compactMap({string in string!}) ?? []
        
        releaseDate = dateFromMongoDB(apolloResult.releaseDate ?? "")
        
        // Initialise Artist
        self.artist = ListnArtist(apolloResult: (apolloResult.artist?.fragments.artistDetail)!)
        
        // Initialise streamingUrls
        self.streamingUrls = ListnStreamingUrls(appleMusic: apolloResult.streamingUrls?.appleMusic ?? "https://music.apple.com/us/search?term=\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))%20\(apolloResult.artist!.fragments.artistDetail.name!.replacingOccurrences(of: " ", with: "%20"))", spotify: apolloResult.streamingUrls?.spotify ?? "https://play.spotify.com/search/\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))%20\(apolloResult.artist!.fragments.artistDetail.name!.replacingOccurrences(of: " ", with: "%20"))")
    }
    
    init(apolloResult: ReviewAlbumDetail, artist: ReviewArtistDetail) {
        // Initialise all strings
        _id = apolloResult._id!
        name = apolloResult.name!
        artwork = apolloResult.artwork ?? ""
        genres = apolloResult.genres?.compactMap({string in string!}) ?? []
        
        // Initialise date
        releaseDate = dateFromMongoDB(apolloResult.releaseDate ?? "")
        
        // Initialise Artist
        self.artist = ListnArtist(apolloResult: artist)
        
        // Initialise streamingUrls
        streamingUrls = ListnStreamingUrls(appleMusic: apolloResult.streamingUrls?.appleMusic ?? "https://music.apple.com/us/search?term=\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))%20\(artist.name!.replacingOccurrences(of: " ", with: "%20"))", spotify: apolloResult.streamingUrls?.spotify ?? "https://play.spotify.com/search/\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))%20\(artist.name!.replacingOccurrences(of: " ", with: "%20"))")
    }
    
    var _id : String
    var name : String
    var artwork : String?
    var smallArtwork : String? {
        get {
            return artwork?.replacingOccurrences(of: "1024x1024", with: "300x300")
        }
    }
    var releaseDateString : String {
        get {
            return releaseDate?.toString(format: "dd MMM YYYY") ?? ""
        }
    }
    var genre : String {
        get {
            if let genres = genres {
                if genres.count > 0 {
                    return genres[0]
                }
                else {
                    return ""
                }
            }
            else {
                return ""
            }
        }
    }
    var releaseDate : Date?
    var genres : [String]?
    var streamingUrls : ListnStreamingUrls
    var artist : ListnArtist
}

struct ListnArtist {
    
    init(apolloResult: ReviewArtistDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        image = apolloResult.image ?? ""
        streamingUrls = ListnStreamingUrls(appleMusic: apolloResult.streamingUrls?.appleMusic ?? "https://music.apple.com/us/search?term=\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))", spotify: apolloResult.streamingUrls?.spotify ?? "https://play.spotify.com/search/\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))")
    }
    init(apolloResult: ArtistDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        image = apolloResult.image ?? ""
        streamingUrls = ListnStreamingUrls(appleMusic: apolloResult.streamingUrls?.appleMusic ?? "https://music.apple.com/us/search?term=\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))", spotify: apolloResult.streamingUrls?.spotify ?? "https://play.spotify.com/search/\(apolloResult.name!.replacingOccurrences(of: " ", with: "%20"))")
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
        isCritic = apolloResult.isCritic ?? false
        
        link = apolloResult.link
        
        user = ListnUser(apolloResult: apolloResult.userData!.fragments.reviewUserDetail)
        
        // Initialise date
        date = dateFromMongoDB(apolloResult.date ?? "")
        text = apolloResult.text
        
        album = ListnAlbum(apolloResult: apolloResult.albumData!.fragments.reviewAlbumDetail, artist: apolloResult.artistData!.fragments.reviewArtistDetail)
        
        
    }
    
    init(album: ListnAlbum, score:String, text:String, user:ListnUser) {
        self.album = album
        self.score = score
        self.text = text
        self.isCritic = false
        self.date = Date()
        self.user = user
    }
    
    init(forPreview: Bool) {
        _id = ""
        user = ListnUser(forPreview:true)
        album = ListnAlbum(forPreview: true)
        isCritic = true
        link = ""
        score = "90"
        date = Date()
        text = "Album detail text"
    }
    
    var _id : String?
    var user : ListnUser
    var album : ListnAlbum
    var isCritic : Bool
    var link : String?
    var score : String
    var date : Date
    var text: String?
}


struct ListnUser {
    init(apolloResult: UserDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        username = apolloResult.username!
        link = apolloResult.link
        isCritic = apolloResult.isCritic ?? false
    }
    init(apolloResult: ReviewUserDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        link = apolloResult.link
        isCritic = apolloResult.isCritic ?? false
        username = apolloResult.username!
    }
    init(user:User) {
        self.name = user.name!
        self._id = user._id!.stringValue
        self.link = user.link
        self.username = user.username!
        self.isCritic = false
    }
    var name : String
    var _id : String
    var username : String
    var link : String?
    var isCritic : Bool
}

