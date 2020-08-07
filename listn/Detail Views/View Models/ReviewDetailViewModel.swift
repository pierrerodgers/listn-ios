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
    
    init(review: ListnReview, app: ListnApp) {
        self.review = review
        self.app = app
    }
    
    func toggleReviewLike() {
        
    }
}
