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
    var reviewIds : [String]
    
    private var currentIndex = 0
    private var isLoading = false
    
    init(app: ListnApp) {
        self.app = app
        self.reviews = []
        self.reviewIds = []
        
        app.getUserFeed() { [weak self] reviewIds in
            self!.reviewIds = reviewIds
            self!.getNextPage()
        }
        
        
    }
    
    func getNextPage() {
        if isLoading == false {
            isLoading = true
            print("GETTING NEXT PAGE, currentIndex:\(currentIndex)")
            let max = reviewIds.count - 1
            let start = currentIndex
            let end = min(currentIndex+40, max)
            if max != currentIndex {
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
