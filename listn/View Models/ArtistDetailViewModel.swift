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
    @Published var reviews : Array<ListnReview>
    
    var app : ListnApp
    
    init(artist: ListnArtist, app: ListnApp) {
        print("Initialising for artist: \(artist.name)")
        self.artist = artist
        self.app = app
        reviews = []
    }
    
    func getReviews() {
        app.appData?.getReviews(artistId: artist._id) { error, reviews in
            guard error == nil else {
                return
            }
            self.reviews = reviews!
        }
    }

    
    
}
