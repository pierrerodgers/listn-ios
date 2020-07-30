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
    
    var appData : AppData
    
    init(appData: AppData) {
        self.appData = appData
    }
    
    func search(search:String) {
        searchAlbums(search: search)
        searchArtists(search: search)
    }
    
    func searchAlbums(search:String) {
        print(search)
        appData.searchAlbums(query: search) { (error, results) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            self.appData.getAlbums(albumIds:results!, completion:{ (error, results) in
                guard error == nil else {
                    print (error.debugDescription)
                    return
                }
                self.albumResults = results!
            })
        }
    }
    
    func searchArtists(search:String) {
        appData.searchArtists(query: search) { (error, results) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            self.appData.getArtists(artistIds:results!, completion:{ (error, results) in
                guard error == nil else {
                    print (error.debugDescription)
                    return
                }
                self.artistResults = results!
            })
        }
    }
    
    
}
