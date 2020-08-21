//
//  AlbumDetailCard.swift
//  listn
//
//  Created by Pierre Rodgers on 15/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchAlbumRow: View {
    var album : ListnAlbum
    
    
    var body: some View {
        HStack{
            WebImage(url: URL(string:album.smallArtwork ?? "")).resizable().placeholder(content: {Rectangle()}).frame(width:130, height: 130)
            //Spacer()
            VStack (alignment:.leading) {
                Text(album.name).bold()
                Text(album.artist.name)
                Spacer()
                Text("\(album.genre) - \(album.releaseDateString)")
                
            }.padding(.vertical)
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight:130)
        
    }
}

struct SearchAlbumRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchAlbumRow(album:ListnAlbum(forPreview: true))
    }
}
