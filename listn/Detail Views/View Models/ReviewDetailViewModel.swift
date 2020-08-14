//
//  ReviewDetailViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 7/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit

class ReviewDetailViewModel: ObservableObject {
    var app : ListnApp
    
    @Published var review : ListnReview
    @Published var moreAlbumReviews : Array<ListnReview>
    @Published var moreReviewerReviews : Array<ListnReview>
    
    init(review: ListnReview, app: ListnApp) {
        self.review = review
        self.moreReviewerReviews = []
        self.moreAlbumReviews = []
        self.app = app
        refreshReviews()
    }
    
    func refreshReviews() {
        app.getReviews(albumId: review.album._id, completion: { error, reviews in
            guard error == nil else {
                return
            }
            self.moreAlbumReviews = reviews!
        })
        
        if review.reviewType == .critic {
            let criticReview = review as! ListnCriticReview
            app.getReviews(reviewerId: criticReview.reviewer._id, completion: { error, reviews in
                guard error == nil else {
                    return
                }
                self.moreReviewerReviews = reviews!
            })
        }
        else {
            /*let userReview = review as! ListnUserReview
            app.getUs: userReview.user?._id, completion: { error, reviews in
                guard error == nil else {
                    return
                }
                self.moreReviewerReviews = reviews!
            })*/
        }
    }
    
    func toggleReviewLike() {
        
    }
}
