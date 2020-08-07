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
        VStack {
            Text(model.reviewer.name)
            Button(action:model.toggleFollow) {
                if model.isFollowing {
                    Text("Unfollow")
                }
                else {
                    Text("Follow")
                }
            }
            List(model.recentReviews, id:\._id) { review in
                VStack {
                    Text(review.album.name)
                    Text(review.album.artist.name)
                    Text(review.score)
                }
                
            }
        }
    }
}
/*
struct ReviewerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewerDetailView()
    }
}*/
