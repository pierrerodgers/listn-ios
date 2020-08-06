//
//  SearchViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit

class SearchViewModel: ObservableObject {
    @Published var albumResults : Array<ListnAlbum> = []
    @Published var artistResults : Array<ListnArtist> = []
    @Published var reviewerResults: Array<ListnReviewer> = []
    
    var app : ListnApp
    
    init(app: ListnApp) {
        self.app = app
    }
    
    func search(query: String) {
        app.search(query: query) { error, results in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            self.albumResults = results!.albums
            self.artistResults = results!.artists
            self.reviewerResults = results!.reviewers
        }
    }
    
}
