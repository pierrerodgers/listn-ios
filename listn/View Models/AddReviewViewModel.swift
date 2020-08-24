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
struct ReviewInputValidState {
    var missingScore = true
    var invalidScore = false
    var missingAlbum = true
    var valid = false
}

class AddReviewViewModel: ObservableObject {
    
    var app : ListnApp
    
    @Published var album : ListnAlbum?
    @Published var inputValid : ReviewInputValidState
    
    var user: ListnUser
    
    
    init(album:ListnAlbum?, app: ListnApp, user: ListnUser) {
        self.album = album
        self.app = app
        if album == nil {
            self.inputValid = ReviewInputValidState()
        }
        else {
            self.inputValid = ReviewInputValidState(missingAlbum:false)
        }
        self.user = user
        
    }
    
    func postReview(review: NewReview) {
        let review = ListnReview(album:album!, score:String(review.score), text: review.text, user: user)
        
        app.postReview(review: review)
    }
    
}
