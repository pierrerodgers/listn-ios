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
    @Published var user : User
    @Published var userReviews : Array<ListnUserReview> = []
    
    var reviewsCancellable : AnyCancellable?
    
    init(app: ListnApp) {
        self.app = app
        self.user = app.user!.freeze()
        updateReviews()
    }
    
    func updateReviews() {
        reviewsCancellable =
            app.userReviewsPublisher(query: ListnApp.ListnUserReviewQuery(user:user._id.stringValue))
            .catch { error -> Just<[ListnUserReview]> in
                print(error)
                return Just([])
            }
            .assign(to:\.userReviews, on: self)
            
    }
}
