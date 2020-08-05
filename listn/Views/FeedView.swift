//
//  FeedView.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var model : FeedModel
    
    var body: some View {
        NavigationView {
            List(model.reviews.enumerated().map({$0}), id: \.element._id) { index, review in
                NavigationLink(destination: AlbumDetailView(model: AlbumDetailViewModel(album: review.album, app: self.model.app)) ) {
                    VStack(alignment: .leading) {
                        Text(review.album.name)
                        Text(review.album.artist.name)
                        Text(review.reviewer.name)
                        Text(review.score)
                    }.onAppear() {
                        if index == self.model.reviews.count - 10 {
                            self.model.getNextPage()
                        }
                    }
                }
                
                
            }

        }
    }
}
/*
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
*/
