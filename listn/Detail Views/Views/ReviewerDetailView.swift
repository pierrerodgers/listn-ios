//
//  ReviewerDetailView.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct ReviewerDetailView: View {
    @ObservedObject var model : ReviewerDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    Text("135 followers")
                    Text("150 following")
                }
                FollowButton(action: model.toggleFollow)
                ForEach(model.recentReviews, id:\._id) { review in
                    FeedReviewCard(review: review)
                }
            }.frame(maxWidth:.infinity)
        }.navigationBarTitle(model.reviewer.name).frame(maxWidth:.infinity)
    }
}
/*
struct ReviewerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewerDetailView()
    }
}*/
