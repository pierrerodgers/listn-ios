//
//  AlbumDetailView.swift
//  listn
//
//  Created by Pierre Rodgers on 4/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumDetailView: View {
    @ObservedObject var model : AlbumDetailViewModel
    
    var body: some View {
        ScrollView() {
            VStack {
                AlbumDetailCard(album: model.album, app:model.app)
                
                NavigationLink(destination: LazyView(AddReviewView(model: AddReviewViewModel(album: self.model.album, app: self.model.app)))) {
                    Text("Add review for this album")
                }
                ButtonStack(streamingUrls: self.model.album.streamingUrls)
                ForEach(model.reviews, id:\._id) { review in
                    ReviewRow(review: review)
                }
                
                
            }
        }
    }
}
/*
struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView()
    }
}
*/
