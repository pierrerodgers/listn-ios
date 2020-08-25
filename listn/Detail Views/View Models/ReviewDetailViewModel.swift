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
    
    @Published var isLiked : Bool
    @Published var comments : [ListnComment]
    
    @Published var isCommenting : Bool = false
    
    private var disposables = Set<AnyCancellable>()
    
    init(review: ListnReview, app: ListnApp) {
        self.review = review
        self.moreReviewerReviews = []
        self.moreAlbumReviews = []
        self.comments = []
        self.app = app
        self.isLiked = app.isLiked(review._id!)
        refreshReviews()
        getComments()
        refresh()
    }
    
    func getComments() {
        app.commentPublisher(query: ListnApp.ListnCommentQuery(review: review._id!))
        .tryMap { comment in
            comment as [ListnComment]
        }
        .catch{ (error) -> Just<[ListnComment]> in
            print(error)
            return Just([])
        }
        .assign(to: \.comments, on: self)
        .store(in: &disposables)
    }
    
    func refresh() {
        print("with delay at time: \(Date().toString(format: "HH:ss.SSS"))")
        app.reviewPublisher(query: ListnApp.ListnReviewQuery(id:review._id!))
        .catch{ (error) -> Just<ListnReview> in
            print(error)
            return Just(self.review)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {_ in }, receiveValue: { value in
            print("after delay at time: \(Date().toString(format: "HH:ss.SSS"))")
            self.review = value
        })
        .store(in: &disposables)
        
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
        
        
        app.reviewsPublisher(query: ListnApp.ListnReviewQuery(user:review.user._id))
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
    
    func toggleReviewLike() {
        app.toggleLike(reviewId: review._id!)
        isLiked = app.isLiked(review._id!)
        review.likes! += (isLiked) ? 1 : -1
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refresh()
        }
    }
    
    func postComment(comment: ListnComment) {
        app.postComment(comment: comment)
        self.comments.append(comment)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.getComments()
        }
    }
}
