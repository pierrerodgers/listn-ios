//
//  ReviewDetailView.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct ReviewDetailView: View {
    @ObservedObject var model : ReviewDetailViewModel
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                ReviewDetailReviewCard(review: model.review).padding(5)
                ReviewDetailAlbumCard(album: model.review.album, app:model.app).padding(5)
                Text("More reviews for \(model.review.album.name)").font(.headline)
                ForEach(model.moreAlbumReviews.prefix(5), id:\._id) { review in
                    ReviewRow(review:review)
                }
                Text("More from @\(self.model.review.username)").font(.headline)
                ForEach(model.moreReviewerReviews.prefix(5), id:\._id) { review in
                    FeedReviewCard(review: review)
                }
                
                /*
                NavigationLink(destination:LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: self.model.review.album, app: self.model.app)))){
                    Text(model.review.album.name)
                }
                NavigationLink(destination:LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist: self.model.review.album.artist, app: self.model.app)))){
                    Text(model.review.album.artist.name)
                }
                Text(model.review.score)
                Text(model.review.username)*/
            }.offset(x: 0, y: -50)
        }
    }
}
/*
struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetailView()
    }
}
*/
