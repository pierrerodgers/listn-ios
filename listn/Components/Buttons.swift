//
//  Buttons.swift
//  listn
//
//  Created by Pierre Rodgers on 14/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct RaveButton: View {
    @EnvironmentObject var showReviewSheet : ShowReviewSheet
    
    var album : ListnAlbum?
    
    var body: some View {
        Button(action:{
            self.showReviewSheet.albumReviewing = self.album
            self.showReviewSheet.isAddingReview = true
        }) {
            Text("+ rave").title().padding().background(Color(.gray)).cornerRadius(10)
        }
        
    }
}
struct FullReviewButton : View {
    var link : String
    
    var body: some View {
        Button(action: {}) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 20))
                Text("See full review").font(.system(size: 20))
            }
        }
    }
}

struct SpotifyButton : View {
    var link : String
    
    var body: some View {
        Button(action: {}) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 30))
                Text("Listen on Spotify").font(.system(size: 20)).bold()
            }.frame(minWidth:0, maxWidth: .infinity, minHeight:50, maxHeight: .infinity).padding(5).foregroundColor(.white).background(Color(red: 30/255, green: 215/255, blue: 96/255)).cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct AppleMusicButton : View {
    var link : String
    
    var body: some View {
        Button(action: {}) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 30))
                Text("Listen on Apple Music").font(.system(size: 20)).bold()
            }.frame(minWidth:0, maxWidth: .infinity, minHeight:50, maxHeight: .infinity).padding(5).foregroundColor(.white).background(Color(red: 235/255, green: 87/255, blue: 87/255)).cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ShareButton : View {
    var body: some View {
        Button(action: {}) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 30))
                Text("Share with friends").font(.system(size: 20)).bold()
            }.frame(minWidth:0, maxWidth: .infinity, minHeight:50, maxHeight: .infinity).padding(5).foregroundColor(.white).background(Color.black).cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ButtonStack : View {
    var streamingUrls: ListnStreamingUrls
    
    var body : some View {
        VStack {
            AppleMusicButton(link: streamingUrls.appleMusic)
            SpotifyButton(link: streamingUrls.spotify)
            ShareButton()
        }
    }
}

struct SaveReviewButton : View {
    var action : () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Save rave")
        }
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FullReviewButton(link:"").previewDisplayName("Full review button")
            RaveButton().previewDisplayName("Rave button")
            SpotifyButton(link: "").previewDisplayName("Spotify button")
            AppleMusicButton(link: "").previewDisplayName("Apple Music button")
        }.previewLayout(PreviewLayout.fixed(width: 400, height: 50))
        
    }
}

