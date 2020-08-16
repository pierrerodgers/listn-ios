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
    
    var app : ListnApp
    
    init(album: ListnAlbum, app: ListnApp) {
        print("initialising for album \(album.name)")
        self.app = app
        self.album = album
        reviews = []
        getReviews()
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
    
}
