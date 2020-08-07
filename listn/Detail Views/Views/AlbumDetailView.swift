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
    
    init(model: AlbumDetailViewModel) {
        self.model = model
        model.getReviews()
    }
    
    var body: some View {
        ScrollView() {
            VStack {
                Text(model.album.name)
                Text(model.album.releaseDate?.toString() ?? "")
                
                NavigationLink(destination: LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist: self.model.album.artist, app: self.model.app)))) {
                    Text(self.model.album.artist.name).padding(.vertical)
                }
                
                NavigationLink(destination: LazyView(AddReviewView(model: AddReviewViewModel(album: self.model.album, app: self.model.app)))) {
                    Text("Add review for this album")
                }
                
                WebImage(url: URL(string:model.album.artwork ?? "")).resizable().placeholder(content: {Rectangle()}).frame(width:300, height:300, alignment: .center)
                
                ForEach(model.reviews, id:\._id) { review in
                    VStack(alignment:.leading) {
                        Text(review.score)
                        Text(review.username)
                    }
                    
                    
                }
            }
        }/*.onAppear() {
            self.model.getReviews()
        }*/
    }
}
/*
struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView()
    }
}
*/
