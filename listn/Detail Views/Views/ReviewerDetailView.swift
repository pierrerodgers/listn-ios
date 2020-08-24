//
//  ReviewerDetailView.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import ActivityIndicatorView

struct ReviewerDetailView: View {
    @ObservedObject var model : ReviewerDetailViewModel
    
    var body: some View {
        List {
            HStack{
                Text("135 followers")
                Text("150 following")
            }
            FollowButton(action: model.toggleFollow)
            ForEach(model.recentReviews, id:\._id) { review in
                NavigationLink(destination:LazyView(ReviewDetailView(model: ReviewDetailViewModel(review: review, app: self.model.app)))) {
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
        }.navigationBarTitle(model.user.name)
    }
}
/*
struct ReviewerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewerDetailView()
    }
}*/
