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
        VStack{
            NavigationLink(destination:LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: self.model.review.album, app: self.model.app)))){
                Text(model.review.album.name)
            }
            NavigationLink(destination:LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist: self.model.review.album.artist, app: self.model.app)))){
                Text(model.review.album.artist.name)
            }
            Text(model.review.score)
            Text(model.review.username)
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
