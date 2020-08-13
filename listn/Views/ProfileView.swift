//
//  ProfileView.swift
//  listn
//
//  Created by Pierre Rodgers on 12/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var model : ProfileViewModel
    
    var body: some View {
        NavigationView {
            List(self.model.userReviews, id:\._id) { review in
                NavigationLink(destination: LazyView(ReviewDetailView(model: ReviewDetailViewModel(review: review, app: self.model.app)))) {
                    VStack(alignment:.leading){
                        Text(review.album.name)
                        Text(review.album.artist.name)
                        Text(review.score)
                    }
                }
            }
        }
    }
}
/*
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
*/
