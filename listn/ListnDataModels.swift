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
}

struct ApolloAlbum : ListnAlbum {
    
    init(apolloResult: AlbumQuery.Data.Album) {
        _id = apolloResult._id!
        name = apolloResult.name!
        artwork = apolloResult.artwork ?? ""
        genres = apolloResult.genres?.compactMap({string in string!}) ?? []
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        releaseDate = dateFormatter.date(from: apolloResult.releaseDate ?? "")
    }
    
    
    var _id: String
    
    var name: String
    
    var artwork: String?
    
    var releaseDate: Date?
    
    var genres: [String]?
    
}
