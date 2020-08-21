//
//  SearchArtistRow.swift
//  listn
//
//  Created by Pierre Rodgers on 20/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchArtistRow: View {
    var artist : ListnArtist
    
    var body: some View {
        HStack{
            WebImage(url: URL(string:artist.image)).resizable().placeholder(content: {Rectangle()}).frame(width:80, height: 80).aspectRatio(contentMode: .fit).clipped()
            Text(artist.name)
            Spacer()
        }.frame(maxWidth:.infinity, maxHeight:80)
    }
}

struct SearchArtistRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchArtistRow(artist:ListnArtist(forPreview: true))
    }
}
