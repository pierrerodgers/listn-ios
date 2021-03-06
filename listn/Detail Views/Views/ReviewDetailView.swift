//
//  ReviewDetailView.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct ReviewDetailView: View {
    @EnvironmentObject var model : ReviewDetailViewModel
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                ReviewDetailReviewCard(review: model.review).padding(5)
                ReviewDetailAlbumCard(album: model.review.album, app: model.app)
                Text("More reviews for \(model.review.album.name)").font(.headline)
                ForEach(model.moreAlbumReviews.prefix(5), id:\._id) { review in
                    ReviewRow(review:review)
                }
                Text("More from @\(self.model.review.user.username)").font(.headline)
                ForEach(model.moreReviewerReviews.prefix(5), id:\._id) { review in
                    NavigationLink(destination: LazyView(ReviewDetailView().environmentObject(ReviewDetailViewModel(review: review, app: self.model.app)))) {
                        FeedReviewCard(review: review)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
    }
}
/*
struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetailView()
    }
}
*/
