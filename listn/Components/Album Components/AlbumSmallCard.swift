//
//  AlbumSmallCard.swift
//  listn
//
//  Created by Pierre Rodgers on 16/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumSmallCard: View {
    var album : ListnAlbum
    
    var body: some View {
        VStack{
            WebImage(url: URL(string: album.smallArtwork ??  "")).resizable().placeholder(){Rectangle()}.frame(width: 200, height: 200)
            VStack(alignment:.leading) {
                Text(album.name).bold()
                Text("Released \(album.releaseDateString)").font(.system(size: 14, weight: .light))
            }
        }
    }
}

struct AlbumSmallCard_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSmallCard(album: ListnAlbum(forPreview: true))
    }
}
