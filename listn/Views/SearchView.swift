//
//  SearchView.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import GenericSegmentedControl

enum SearchViewType : String, SegmentBindable {
    case albums, artists, reviewers
    var description: String {
        self.rawValue.capitalized
    }
}

struct SearchView: View {
    @ObservedObject var model : SearchViewModel
    @State var selectedType : SearchViewType = SearchViewType.albums
    
    @State var query : String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $query)
                Button(action:{self.model.search(query: self.query)}) {
                    Text("Search!")
                }
                SegmentedControl($selectedType)
                if selectedType == .albums {
                    List(model.albumResults, id:\._id) { album in
                        NavigationLink(destination:LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: album, app: self.model.app)))) {
                            VStack{
                                Text(album.name)
                                Text(album.artist.name)
                            }
                        }
                    }
                }
                if selectedType == .artists {
                    List(model.artistResults, id:\._id) { artist in
                        NavigationLink(destination:LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist: artist, app: self.model.app)))) {
                            Text(artist.name)
                        }
                        
                    }
                }
                if selectedType == .reviewers {
                    List(model.reviewerResults, id:\._id) { reviewer in
                        Text(reviewer.name)
                    }
                }
            }.navigationBarTitle("").navigationBarHidden(true)
        }
    }
    /*
    func onSelected(index: Int) {
        switch index {
        case 0:
            selectedType = .albums
        case 1:
            selectedType = .artists
        case 2:
            selectedType = .reviewers
        default:
            selectedType = .albums
        }
    }*/
}
/*
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
*/
