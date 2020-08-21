//
//  ReviewDetailViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 7/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import Combine

class ReviewDetailViewModel: ObservableObject {
    var app : ListnApp
    
    @Published var review : ListnReview
    @Published var moreAlbumReviews : Array<ListnReview>
    @Published var moreReviewerReviews : Array<ListnReview>
    
    private var disposables = Set<AnyCancellable>()
    
    init(review: ListnReview, app: ListnApp) {
        self.review = review
        self.moreReviewerReviews = []
        self.moreAlbumReviews = []
        self.app = app
        refreshReviews()
    }
    
    func refreshReviews() {
        app.reviewsPublisher(query: ListnApp.ListnReviewQuery(album:review.album._id))
        .tryMap { review in
            review as [ListnReview]
        }
        .catch{ (error) -> Just<[ListnReview]> in
            print(error)
            return Just([])
        }
        .assign(to: \.moreAlbumReviews, on: self)
        .store(in: &disposables)
        
        
        if review.reviewType == .critic {
            let criticReview = review as! ListnCriticReview
            app.reviewsPublisher(query: ListnApp.ListnReviewQuery(reviewer:criticReview.reviewer._id))
            .tryMap { review in
                review as [ListnReview]
            }
            .catch{ (error) -> Just<[ListnReview]> in
                print(error)
                return Just([])
            }
            .assign(to: \.moreReviewerReviews, on: self)
            .store(in: &disposables)
        }
      
    }
    
    func toggleReviewLike() {
        
    }
}
