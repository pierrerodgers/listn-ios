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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        releaseDate = dateFormatter.date(from: apolloResult.releaseDate ?? "")
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        releaseDate = dateFormatter.date(from: apolloResult.releaseDate ?? "")
        
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

struct ListnCriticReview : ListnReview {
    
    init(apolloResult: ReviewDetail) {
        _id = apolloResult._id!
        score = apolloResult.score!
        link = apolloResult.link!
        
        // Initialise date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        date = dateFormatter.date(from: apolloResult.date ?? "") ?? Date()
        
        album = ListnAlbum(apolloResult: apolloResult.albumData!.fragments.reviewAlbumDetail, artist: apolloResult.artistData!.fragments.reviewArtistDetail)
        
        reviewer = ListnReviewer(apolloResult: apolloResult.reviewerData!.fragments.reviewReviewerDetail)
        
    }
    
    var _id : String?
    var reviewer : ListnReviewer
    var username : String {
        get {
            return reviewer.name
        }
    }
    var album : ListnAlbum
    var link : String?
    var score : String
    var date : Date
    var text: String?
    var reviewType: ReviewType = .critic
}

struct ListnReviewer {
    init(apolloResult: ReviewReviewerDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        link = apolloResult.link!
    }
    init(apolloResult: ReviewerDetail) {
        _id = apolloResult._id!
        name = apolloResult.name!
        link = apolloResult.link!
    }
    
    
    var _id : String
    var name : String
    var link : String
}

struct ListnUser {
    init(apolloResult: UserDetail) {
        _id = apolloResult._id
        name = apolloResult.name
        username = apolloResult.username!
    }
    var name : String
    var _id : String
    var username : String
}

struct ListnUserReview : ListnReview {
    init(apolloResult: UserReviewDetail) {
        _id = apolloResult._id!
        score = apolloResult.score!
        text = apolloResult.text ?? ""
        
        // Initialise date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        date = dateFormatter.date(from: apolloResult.date ?? "") ?? Date()
        
        album = ListnAlbum(apolloResult: apolloResult.album!.fragments.albumDetail)
        user = ListnUser(apolloResult: apolloResult.user!.fragments.userDetail)
                
    }
    
    init(album:ListnAlbum, score: String, text: String?) {
        self.album = album
        self.score = score
        self.text = text
        self.date = Date()
    }
    var _id : String?
    var album : ListnAlbum
    var score : String
    var date : Date
    var text : String?
    var user : ListnUser?
    var reviewType: ReviewType = .user
    var link : String?
    var username : String {
        get {
            return user?.username ?? ""
        }
    }
}

protocol ListnReview {
    var username :String { get }
    var score : String { get }
    var text : String? { get }
    var date : Date { get }
    var _id : String? { get }
    var album : ListnAlbum { get }
    var reviewType : ReviewType { get }
    var link : String? { get }
}
enum ReviewType {
    case user, critic
}
