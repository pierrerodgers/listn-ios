//
//  ArtistDetailViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 4/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Combine

class ArtistDetailViewModel : ObservableObject {
    
    @Published var artist: ListnArtist
    @Published var reviews : Array<ListnReview> = []
    @Published var albums : Array<ListnAlbum> = []
    
    private var disposables = Set<AnyCancellable>()
    
    var app : ListnApp
    
    init(artist: ListnArtist, app: ListnApp) {
        print("Initialising for artist: \(artist.name)")
        self.artist = artist
        self.app = app
        
    }
    
    func getReviews() {
        app.reviewsPublisher(query: ListnApp.ListnReviewQuery(artist:artist._id))
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
        app.albumPublisher(query: ListnApp.ListnAlbumQuery(artist:artist._id))
        .catch{ (error) -> Just<[ListnAlbum]> in
            print(error)
            return Just([])
        }
        .assign(to: \.albums, on: self)
        .store(in: &disposables)
    }

    
    
}
