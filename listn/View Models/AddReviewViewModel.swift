//
//  AddReviewViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 5/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

/*enum ReviewInputValid {
    case missingScore, invalidScore, missingAlbum, valid
}
*/
struct ReviewInputValid {
    var missingScore = true
    var invalidScore = false
    var missingAlbum = true
    var valid = false
}

class AddReviewViewModel: ObservableObject {
    
    var app : ListnApp
    
    @Published var album : ListnAlbum
    @Published var inputValid : ReviewInputValid
    
    
    init(album:ListnAlbum, app: ListnApp) {
        self.album = album
        self.app = app
        self.inputValid = ReviewInputValid()
    }
    
    func postReview(review: NewReview) {
        let review = ListnUserReview(album:album, score:String(review.score), text: review.text)
        
        app.postReview(review: review)
    }
    
}
