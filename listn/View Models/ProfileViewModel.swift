//
//  ProfileViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 12/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit

class ProfileViewModel: ObservableObject {
    var app : ListnApp
    @Published var user : User
    @Published var userReviews : Array<ListnReview> = []
    
    init(app: ListnApp) {
        self.app = app
        self.user = app.user!.freeze()
        updateReviews()
    }
    
    func updateReviews() {
        app.getUserReviews() { error, reviews in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.userReviews = reviews!
        }
    }
}
