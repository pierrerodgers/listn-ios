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
    @Published var userResults: Array<ListnUser> = []
    
    @Published var isLoading : Bool = false
    
    @Published var query : String = "" {
        didSet {
            searchCancellable?.cancel()
            isLoading = true
            if self.query == "" {
                self.albumResults = []
                self.userResults = []
                self.artistResults = []
            }
            searchCancellable = app.searchPublisher(query: self.query).sink(
                receiveCompletion: { [weak self] completion in
                    self!.isLoading = false
                    switch completion {
                    case .failure(let error ):
                        self!.albumResults = []
                        self!.artistResults = []
                        self!.userResults = []
                        print(error)
                    case .finished:
                        self!.isLoading = false
                    }
            }, receiveValue: { [weak self] searchResults in
                print(searchResults)
                self!.albumResults = searchResults.albums
                self!.artistResults = searchResults.artists
                self!.userResults = searchResults.users
                
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
