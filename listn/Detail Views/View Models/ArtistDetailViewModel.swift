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
    
    var app : ListnApp
    
    init(artist: ListnArtist, app: ListnApp) {
        print("Initialising for artist: \(artist.name)")
        self.artist = artist
        self.app = app
        
    }
    
    func getReviews() {
        app.getReviews(artistId: artist._id) { error, reviews in
            guard error == nil else {
                return
            }
            print("Reviews for artist \(self.artist.name) fetched")
            self.reviews = reviews!
        }
    }
    
    func getAlbums() {
        app.getAlbums(artistId: artist._id) { error, albums in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            print("Albums for artist \(self.artist.name) fetched")
            self.albums = albums!
            
        }
    }

    
    
}
