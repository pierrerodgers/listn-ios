//
//  ReviewDetailAlbumCard.swift
//  listn
//
//  Created by Pierre Rodgers on 14/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReviewDetailAlbumCard: View {
    var album : ListnAlbum
    var app : ListnApp?
    
    var body: some View {
        HStack{
            WebImage(url: URL(string:album.smallArtwork ?? "")).resizable().placeholder(content: {Rectangle()}).frame(width:180, height: 180)
            VStack (alignment:.leading){
                NavigationLink(destination:LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: self.album, app: self.app!)))){
                    VStack(alignment:.leading){
                        Text(album.name).title()
                        Text(album.artist.name)
                    }
                }.buttonStyle(PlainButtonStyle())
                Spacer()
                RaveButton()
            }.padding(.vertical, 5)
            Spacer()
        }
    }
}

struct ReviewDetailAlbumCard_Previews: PreviewProvider {
    static var previews: some View {
        let album = ListnAlbum(forPreview: true)
        return ReviewDetailAlbumCard(album:album).previewLayout(PreviewLayout.fixed(width: 414, height: 180))
    }
}
