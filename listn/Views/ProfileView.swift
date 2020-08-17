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
            ScrollView {
                VStack {
                    HStack{
                        Text("130 Followers")
                        Text("130 Following")
                    }
                    ForEach(self.model.userReviews, id:\._id) { review in
                        NavigationLink(destination: LazyView(ReviewDetailView(model: ReviewDetailViewModel(review: review, app: self.model.app)))) {
                            FeedReviewCard(review: review)
                        }.buttonStyle(PlainButtonStyle())
                        

                    }
                }
            }.frame(maxWidth:.infinity).navigationBarTitle(model.user.name)
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
