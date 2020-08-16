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
                
                Text("Critic reviews").font(.headline)
                ForEach(model.reviews, id:\._id) { review in
                    NavigationLink(destination: LazyView(ReviewDetailView(model:ReviewDetailViewModel(review: review, app: self.model.app)))) {
                        ReviewRow(review: review)
                    }.buttonStyle(PlainButtonStyle())
                }
                
                
                ScrollView (.horizontal){
                    HStack{
                        ForEach(model.otherAlbums, id:\._id) { album in
                            NavigationLink(destination:LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: album, app: self.model.app)))) {
                                AlbumSmallCard(album: album)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }.padding(.horizontal)
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
