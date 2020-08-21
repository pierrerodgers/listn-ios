//
//  AlbumDetailViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 4/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import Combine

class AlbumDetailViewModel: ObservableObject {
    @Published var album : ListnAlbum
    @Published var reviews : Array<ListnReview>
    @Published var otherAlbums : Array<ListnAlbum>
    
    var app : ListnApp
    
    private var disposables = Set<AnyCancellable>()
    
    init(album: ListnAlbum, app: ListnApp) {
        self.app = app
        self.album = album
        self.otherAlbums = []
        reviews = []
        getReviews()
        getAlbums()
    }
    
    func getReviews() {
        app.reviewsPublisher(query: ListnApp.ListnReviewQuery(album:album._id))
        .tryMap { review in
            review as [ListnReview]
        }
        .catch{ (error) -> Just<[ListnReview]> in
            print(error)
            return Just([])
        }
        .assign(to: \.reviews, on: self)
        .store(in: &disposables)
    }
    
    func getAlbums() {
        app.albumPublisher(query: ListnApp.ListnAlbumQuery(artist:album.artist._id))
        .catch{ (error) -> Just<[ListnAlbum]> in
            print(error)
            return Just([])
        }
        .assign(to: \.otherAlbums, on: self)
        .store(in: &disposables)
    }
    
}
