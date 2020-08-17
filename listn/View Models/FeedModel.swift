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
            self.reviews = []
            self.getFirstPage()
        }
    }
    
    func getFirstPage() {
        let maximum = max(reviewIds.count - 1,0)
        let start = currentIndex
        let end = min(currentIndex+40, maximum)
        print("end: \(end), start =\(start)")
        print(reviewIds[start...end])
        if maximum != currentIndex {
            app.getReviewsForIDs(IDs: Array(reviewIds[start...end])) { (error, reviews) in
                guard error == nil else {
                    self.isRefreshing = false
                    return
                }
                self.reviews = reviews!
                self.currentIndex += 40
                self.isRefreshing = false
            }
        }
    }
    
    func getNextPage() {
        
        if isLoading == false {
            isLoading = true
            print("GETTING NEXT PAGE, currentIndex:\(currentIndex)")
            let maximum = max(reviewIds.count - 1,0)
            let start = currentIndex
            let end = min(currentIndex+40, maximum)
            print("end: \(end), start =\(start)")
            print(reviewIds[start...end])
            if maximum != currentIndex {
                app.getReviewsForIDs(IDs: Array(reviewIds[start...end])) { (error, reviews) in
                    guard error == nil else {
                        self.isLoading = false
                        return
                    }
                    self.reviews.append(contentsOf: reviews!)
                    self.currentIndex += 40
                    self.isLoading = false
                }
            }
        }
        
    }
    
    
}
