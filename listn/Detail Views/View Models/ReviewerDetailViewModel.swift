//
//  ReviewerDetailViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import Combine

class ReviewerDetailViewModel: ObservableObject {
    var app : ListnApp
    
    @Published var reviewer : ListnReviewer
    @Published var recentReviews: Array<ListnReview> = []
    @Published var isFollowing : Bool
    
    private var cancellable : AnyCancellable?
    
    init(app: ListnApp, reviewer:ListnReviewer) {
        self.app = app
        self.reviewer = reviewer
        isFollowing = (app.findFollow(reviewerId: reviewer._id) != nil)
        getReviews()
    }
    
    func getReviews() {
        cancellable = app.reviewsPublisher(query: ListnApp.ListnReviewQuery(reviewer:reviewer._id))
        .tryMap { review in
            review as [ListnReview]
        }
        .catch{ (error) -> Just<[ListnReview]> in
            print(error)
            return Just([])
        }
        .assign(to: \.recentReviews, on: self)
    }
    
    func toggleFollow() {
        app.toggleFollow(reviewerId: reviewer._id)
        isFollowing = (app.findFollow(reviewerId: reviewer._id) != nil)
    }
}
