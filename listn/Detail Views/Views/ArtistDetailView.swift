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
        ScrollView(.vertical) {
            VStack {
                ZStack {
                    GeometryReader { geometry in
                        ZStack {
                            if geometry.frame(in: .global).minY <= 0 {
                                WebImage(url: URL(string:self.model.artist.image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(y: geometry.frame(in: .global).minY/9)
                                .clipped()
                            } else {
                                WebImage(url: URL(string:self.model.artist.image))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                    .clipped()
                                    .offset(y: -geometry.frame(in: .global).minY)
                            }
                        }
                    }.frame(height:400)
                    VStack(alignment:.leading){
                        Spacer()
                        HStack{
                            Text(model.artist.name).font(.largeTitle).bold().padding(.horizontal)
                            Spacer()
                        }
                        
                    }
                }
                ButtonStack(streamingUrls: model.artist.streamingUrls)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(model.albums, id:\._id){ album in
                            NavigationLink(destination:AlbumDetailView(model: AlbumDetailViewModel(album: album, app: self.model.app))) {
                                AlbumSmallCard(album: album)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    
                }
                
                ForEach(model.reviews, id:\._id) { review in
                    NavigationLink(destination:LazyView(ReviewDetailView().environmentObject(ReviewDetailViewModel(review: review, app: self.model.app)))) {
                        FeedReviewCard(review: review)
                    }.buttonStyle(PlainButtonStyle())
                     
                }
            }
        }.navigationBarTitle("", displayMode: .large).edgesIgnoringSafeArea(.top)
    }
}



/*struct NavigationBarModifier: ViewModifier {
    
    @Environment(\.presentationMode) var presentation
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Button(action: { self.presentation.wrappedValue.dismiss() }) {
                      HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(UIColor.label))
                          .imageScale(.large)
                      }
                    }
                    //Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
 
    func navBarHidden() -> some View {
        self.modifier(NavigationBarModifier())
    }

}*/

/*struct ArtistDetailView: PreviewProvider {
    static var previews: some View {
        ArtistDetailView()
    }
}
*/
