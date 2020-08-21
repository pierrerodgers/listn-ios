//
//  FeedModel.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import Combine

class FeedModel: ObservableObject {
    // MARK: Overview
    /*
        This class should be independent of whatever database mechanism
        I end up using.
     
        It should only handle UI logic
     */
    
    var app : ListnApp
    
    @Published var reviews : Array<ListnReview>
    @Published var isLoading : Bool
    @Published var isRefreshing : Bool
    
    var reviewIds : [String]
    
    private var disposables = Set<AnyCancellable>()
    
    private var currentIndex = 0
    
    init(app: ListnApp) {
        self.app = app
        self.reviews = []
        self.reviewIds = []
        self.isLoading = false
        self.isRefreshing = false
        
        app.getUserFeed() { [weak self] reviewIds in
            self!.reviewIds = reviewIds
            self!.getNextPage()
        }
    
        
    }
    
    func refreshUserFeed() {
        isRefreshing = true
        app.refreshUserFeed() { reviewIds in
            self.reviewIds = reviewIds
            self.currentIndex = 0
            self.getFirstPage()
        }
    }
    
    func getFirstPage() {
        
        let maximum = max(reviewIds.count - 1,0)
        let start = currentIndex
        let end = min(currentIndex+40, maximum)
        
        //disposables.removeAll()
        app.feedPublisher(ids: Array(reviewIds[start..<end]))
            .receive(on:DispatchQueue.main)
        .sink(receiveCompletion: { value in
            switch value {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                self.isRefreshing = false
                self.currentIndex += 40
                print("Success!")
            }
        }, receiveValue: { [weak self] value in
            guard let self = self else {
                return
            }
            self.reviews = value
        })
        .store(in: &disposables)
        
    }
    
    func getNextPage() {
        print("getting next page")
        if isLoading == false {
            isLoading = true
            let maximum = max(reviewIds.count - 1,0)
            let start = currentIndex
            let end = min(currentIndex+40, maximum)
            if maximum != currentIndex {
                app.feedPublisher(ids: Array(reviewIds[start..<end]))
                    .receive(on:DispatchQueue.main)
                .sink(receiveCompletion: { value in
                    switch value {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        self.isLoading = false
                        self.currentIndex += 40
                        print("Success!")
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else {
                        return
                    }
                    self.reviews.append(contentsOf: value)
                })
                .store(in: &disposables)
            }
        }
        
    }
    
    
}
