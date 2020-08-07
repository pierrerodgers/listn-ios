//
//  ReviewerDetailViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit

class ReviewerDetailViewModel: ObservableObject {
    var app : ListnApp
    
    @Published var reviewer : ListnReviewer
    @Published var recentReviews: Array<ListnReview> = []
    @Published var isFollowing : Bool
    
    init(app: ListnApp, reviewer:ListnReviewer) {
        self.app = app
        self.reviewer = reviewer
        isFollowing = (app.findFollow(reviewerId: reviewer._id) != nil)
        getReviews()
    }
    
    func getReviews() {
        app.getReviews(reviewerId: reviewer._id) { error, reviews in
            guard error == nil else {
                return
            }
            self.recentReviews = reviews!
        }
    }
    
    func toggleFollow() {
        app.toggleFollow(reviewerId: reviewer._id)
        isFollowing = (app.findFollow(reviewerId: reviewer._id) != nil)
    }
}
