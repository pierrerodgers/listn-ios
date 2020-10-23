//
//  SearchView.swift
//  listn
//
//  Created by Pierre Rodgers on 6/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import GenericSegmentedControl
import ActivityIndicatorView

enum SearchViewType : String, SegmentBindable {
    case albums, artists, reviewers
    var description: String {
        self.rawValue.capitalized
    }
}

struct SearchView: View {
    @ObservedObject var model : SearchViewModel
    @State var selectedType : SearchViewType = SearchViewType.albums
    
    @State var maxAlbumCount = 15
    @State var maxArtistCount = 15
    @State var maxUserCount = 15
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $model.query)
                    Button (action: {
                        self.model.query = ""
                    }){
                        Image(systemName: "x.circle")
                    }
                }.padding(8).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1)).padding(.horizontal)
                
                ActivityIndicatorView(isVisible: $model.isLoading, type: .arcs).frame(width:50, height:50)
                List {
                    ForEach(model.albumResults[0..<min(model.albumResults.count, maxAlbumCount)], id:\._id) { album in
                        NavigationLink(destination:LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: album, app: self.model.app)))) {
                            SearchAlbumRow(album: album)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    ForEach(model.artistResults[0..<min(model.artistResults.count, maxArtistCount)], id:\._id) { artist in
                        NavigationLink(destination:LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist:artist, app: self.model.app)))) {
                            SearchArtistRow(artist: artist)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    ForEach(model.userResults[0..<min(model.userResults.count, maxUserCount)], id:\._id) { user in
                        NavigationLink(destination:LazyView(ProfileView(model: ProfileViewModel(app: self.model.app, user:user)))) {
                            SearchUserRow(user:user)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                }
                
            }.navigationBarTitle("").navigationBarHidden(true)
        }
    }
}
/*
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
*/
