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
    
    @Published var isLoading : Bool = false
    
    @Published var query : String = "" {
        didSet {
            task.cancel()
            let workItem = DispatchWorkItem { [weak self] in
                self!.search(query: self!.query)
            }
            self.task = workItem
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: task)
        }
    }
    
    var task = DispatchWorkItem {
        
    }
    
    var app : ListnApp
    
    init(app: ListnApp) {
        self.app = app
    }
    
    func search(query: String) {
        isLoading = true
        app.search(query: query) { error, results in
            self.isLoading = false
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
