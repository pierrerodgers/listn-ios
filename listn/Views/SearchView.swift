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
        
    var body: some View {
        NavigationView {
            VStack {
                TextField("search", text: $model.query).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal)
                ActivityIndicatorView(isVisible: $model.isLoading, type: .arcs).frame(width:50, height:50)
                List {
                    ForEach(model.albumResults[0..<min(model.albumResults.count, 5)], id:\._id) { album in
                        NavigationLink(destination:LazyView(AlbumDetailView(model: AlbumDetailViewModel(album: album, app: self.model.app)))) {
                            SearchAlbumRow(album: album)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    ForEach(model.artistResults[0..<min(model.artistResults.count, 5)], id:\._id) { artist in
                        NavigationLink(destination:LazyView(ArtistDetailView(model: ArtistDetailViewModel(artist:artist, app: self.model.app)))) {
                            SearchArtistRow(artist: artist)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    ForEach(model.reviewerResults[0..<min(model.reviewerResults.count, 5)], id:\._id) { reviewer in
                        NavigationLink(destination:LazyView(ReviewerDetailView(model: ReviewerDetailViewModel(app: self.model.app, reviewer:reviewer)))) {
                            SearchReviewerRow(reviewer: reviewer)
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
