//
//  TestSearchView.swift
//  listn
//
//  Created by Pierre Rodgers on 29/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct TestSearchView: View {
    @ObservedObject var model : TestSearchViewModel
    @State var query : String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $query)
                Button(action: {
                    print("Searching with query \(self.query)")
                    self.model.search(search: self.query)
                }, label: {
                    Text("Search!")
                })
                Text("Albums")
                List(model.albumResults, id:\._id) { album in
                    NavigationLink(destination: LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: album, app: self.model.app)))) {
                        VStack {
                            Text(album.name)
                            Text(album.artist.name)
                        }
                    }
                }
                Text("Artists")
                List(model.artistResults, id:\._id) { artist in
                    NavigationLink(destination: LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist: artist, app: self.model.app)))) {
                        VStack {
                            Text(artist.name)
                        }
                    }
                    
                }
                    
            }
        }
        
        
    }
}
/*
struct TestSearchView_Previews: PreviewProvider {
    static var previews: some View {
        TestSearchView()
    }
}
*/
