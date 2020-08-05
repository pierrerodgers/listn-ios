//
//  ArtistView.swift
//  listn
//
//  Created by Pierre Rodgers on 4/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistDetailView: View {
    @ObservedObject var model : ArtistDetailViewModel
    
    init(model: ArtistDetailViewModel) {
        self.model = model
        self.model.getReviews()
        self.model.getAlbums()
    }
    
    var body: some View {
        ScrollView() {
            VStack {
                Text(model.artist.name)
                
                WebImage(url: URL(string:model.artist.image)).resizable().placeholder(content: {Rectangle()}).frame(width:300, height:300, alignment: .center)
                
                ScrollView(.horizontal) {
                    
                    HStack {
                        ForEach(model.albums, id:\._id) { album in
                            NavigationLink(destination: LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: album, app: self.model.app)))) {
                                VStack{
                                    WebImage(url:URL(string:album.artwork ?? "")).resizable().placeholder(content: {Rectangle()}).frame(width:200, height:200, alignment: .center)
                                    Text(album.name)
                                    Text(album.artist.name)
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                }
                
                
                ForEach(model.reviews, id:\._id) { review in
                    VStack {
                        Text(review.score)
                        Text(review.reviewer.name)
                    }
                    
                    
                }
            }
        }
    }
}

/*struct ArtistDetailView: PreviewProvider {
    static var previews: some View {
        ArtistDetailView()
    }
}
*/
