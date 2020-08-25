//
//  ProfileViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 12/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import Combine

class ProfileViewModel: ObservableObject {
    var app : ListnApp
    @Published var user : ListnUser
    @Published var recentReviews : Array<ListnReview> = []
    @Published var isFollowing : Bool = false
    @Published var isLoading : Bool = true
    
    var last : String?

    
    var cancellable : AnyCancellable?
    
    init(app: ListnApp, user: ListnUser) {
        self.app = app
        self.user = user
        isFollowing = (app.findFollow(userId: user._id) != nil)
        getNextPage()
    }
    
    func getNextPage() {
        self.isLoading = true
        cancellable = app.paginatedReviewsPublisher(query: ListnApp.ListnReviewQuery(user:user._id, last: self.last))
        .tryMap { review in
            review as [ListnReview]
        }
        .catch{ (error) -> Just<[ListnReview]> in
            print(error)
            self.isLoading = false
            return Just([])
        }
        .receive(on: DispatchQueue.main)
        .sink() { reviews in
            self.isLoading = false
            self.last = reviews.last?._id
            self.recentReviews.append(contentsOf: reviews)
        }
            
    }
    
    func toggleFollow() {
        app.toggleFollow(userId: user._id)
        isFollowing = (app.findFollow(userId: user._id) != nil)
    }
}
