//
//  TestSearchViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 29/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit

class TestSearchViewModel: ObservableObject {
    @Published var albumResults : Array<ListnAlbum> = []
    @Published var artistResults : Array<ListnArtist> = []
    @Published var reviewerResults: Array<ListnReviewer> = []
    
    var app : ListnApp
    
    init(app: ListnApp) {
        self.app = app
    }
    
    func search(search:String) {
        /*searchAlbums(search: search)
        searchArtists(search: search)*/
    }
    
    func searchArtists(search:String) {
        /*app.searchArtists(query: search) { (error, results) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            self.app.getArtists(artistIds:results!, completion:{ (error, results) in
                guard error == nil else {
                    print (error.debugDescription)
                    return
                }
                self.artistResults = results!
            })
        }*/
    }
    
    
}
