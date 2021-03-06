//
//  AlbumDetailCard.swift
//  listn
//
//  Created by Pierre Rodgers on 15/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumDetailCard: View {
    var album : ListnAlbum
    var app : ListnApp?
    
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Spacer()
                WebImage(url: URL(string:album.smallArtwork ?? "")).resizable().placeholder(content: {Rectangle()}).frame(width:300, height: 300)
                Spacer()
            }
            Group {
                HStack {
                    NavigationLink(destination: LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist: self.album.artist, app: self.app!)))) {
                        VStack(alignment:.leading) {
                            Text(album.name).title()
                            Text(album.artist.name)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    Spacer()
                    RaveButton(album:self.album)
                }
                HStack{
                    Text(album.genre)
                    Text("-")
                    Text(album.releaseDate?.toString(format: "dd MMM YYYY") ?? "")
                }
            }.padding(.horizontal)
            
            
        }
        
    }
}

struct AlbumDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailCard(album:ListnAlbum(forPreview: true))
    }
}
