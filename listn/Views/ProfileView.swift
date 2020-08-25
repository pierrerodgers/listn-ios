//
//  ProfileView.swift
//  listn
//
//  Created by Pierre Rodgers on 12/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import ActivityIndicatorView

struct ProfileView: View {
    @ObservedObject var model : ProfileViewModel
    
    var body: some View {
            List {
                Text("@\(model.user.username)").font(.largeTitle)
                HStack{
                    Text("135 followers")
                    Spacer()
                    Text("150 following")
                }
                FollowButton(action: model.toggleFollow, isFollowing:$model.isFollowing)
                ForEach(model.recentReviews, id:\._id) { review in
                    NavigationLink(destination:LazyView(ReviewDetailView().environmentObject(ReviewDetailViewModel(review: review, app: self.model.app)))) {
                        FeedReviewCard(review: review)
                        .onAppear() {
                            print(review.album.name)
                            if review._id == self.model.last {
                                print(self.model.last ?? "")
                                self.model.getNextPage()
                            }
                        }
                    }.buttonStyle(PlainButtonStyle())
                }
                ActivityIndicatorView(isVisible: $model.isLoading, type: .arcs).frame(width:50, height:50)
            }.navigationBarTitle("", displayMode: .inline)
    }
}
/*
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
*/
