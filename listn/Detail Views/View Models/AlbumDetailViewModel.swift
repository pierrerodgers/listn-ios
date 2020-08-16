//
//  AlbumDetailViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 4/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit

class AlbumDetailViewModel: ObservableObject {
    @Published var album : ListnAlbum
    @Published var reviews : Array<ListnReview>
    @Published var otherAlbums : Array<ListnAlbum>
    
    var app : ListnApp
    
    init(album: ListnAlbum, app: ListnApp) {
        self.app = app
        self.album = album
        self.otherAlbums = []
        reviews = []
        getReviews()
        getAlbums()
    }
    
    func getReviews() {
        app.getReviews(albumId: album._id) { error, reviews in
            guard error == nil else {
                return
            }
            print("Review for album \(self.album.name) fetched")
            self.reviews = reviews!
        }
    }
    
    func getAlbums() {
        app.getAlbums(artistId: album.artist._id) { error, albums in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.otherAlbums = albums!
        }
    }
    
}
