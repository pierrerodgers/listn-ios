//
//  AddReviewViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 5/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

class AddReviewViewModel: ObservableObject {
    
    var app : ListnApp
    
    @Published var album : ListnAlbum
    
    
    init(album:ListnAlbum, app: ListnApp) {
        self.album = album
        self.app = app
    }
    
    func postReview() {
        let review = ListnUserReview(album:album, score:"100", text: "\(album.name)")
        
        app.postReview(review: review)
        
        
    }
    
}
