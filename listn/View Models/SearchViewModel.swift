//
//  SearchViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//
import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var albumResults : Array<ListnAlbum> = []
    @Published var artistResults : Array<ListnArtist> = []
    @Published var reviewerResults: Array<ListnReviewer> = []
    
    @Published var isLoading : Bool = false
    
    @Published var query : String = "" {
        didSet {
            searchCancellable?.cancel()
            searchCancellable = app.searchPublisher(query: self.query).sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error ):
                        print(error)
                    case .finished:
                        self!.isLoading = false
                    }
            }, receiveValue: { [weak self] searchResults in
                self!.albumResults = searchResults.albums
                self!.artistResults = searchResults.artists
                self!.reviewerResults = searchResults.reviewers
                
            })
        }
    }
    
    var task = DispatchWorkItem {
        
    }
    
    var app : ListnApp
    
    var searchCancellable : AnyCancellable?
    
    init(app: ListnApp) {
        self.app = app
        
    }
    
}
