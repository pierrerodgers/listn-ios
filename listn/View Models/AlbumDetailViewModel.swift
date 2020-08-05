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
        self.app = app
        self.album = album
        reviews = []
    }
    
    func getReviews() {
        app.appData?.getReviews(albumId: album._id) { error, reviews in
            guard error == nil else {
                return
            }
            self.reviews = reviews!
        }
    }
    
}
