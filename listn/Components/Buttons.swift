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
        }.buttonStyle(PlainButtonStyle())
        
    }
}

struct NewRaveButton : View {
    @EnvironmentObject var showReviewSheet : ShowReviewSheet
    
    var body: some View {
        Button(action:{
            self.showReviewSheet.isAddingReview = true
            self.showReviewSheet.albumReviewing = nil
        }) {
            Image(systemName: "rectangle.stack.badge.plus").font(.system(size: 30)).foregroundColor(.white).padding(20).background(Circle().foregroundColor(Color(red: 235/255, green: 87/255, blue: 87/255)))
            }.buttonStyle(HoverButtonStyle())
    }
}

struct HoverButtonStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.8 : 1.0).animation(Animation.easeOut(duration: 0.15))
    }
}

struct FullReviewButton : View {
    var link : String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: self.link) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 20))
                Text("See full review").font(.system(size: 20))
                }.padding().background(Color.blue).cornerRadius(5)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct SpotifyButton : View {
    var link : String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: self.link) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 30))
                Text("Listen on Spotify").font(.system(size: 15)).bold()
            }.frame(minWidth:0, maxWidth: .infinity, minHeight:30, maxHeight:30).padding(5).foregroundColor(.white).background(Color(red: 30/255, green: 215/255, blue: 96/255)).cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct AppleMusicButton : View {
    var link : String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: self.link) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 30))
                Text("Listen on Apple Music").font(.system(size: 15))
            }.frame(minWidth:0, maxWidth: .infinity, minHeight:30, maxHeight: 30).padding(5).foregroundColor(.white).background(Color(red: 235/255, green: 87/255, blue: 87/255)).cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ShareButton : View {
    var body: some View {
        Button(action: {
            
        }) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 30))
                Text("Share with friends").font(.system(size: 15))
            }.frame(minWidth:0, maxWidth: .infinity, minHeight:30, maxHeight: 30).padding(5).foregroundColor(.white).background(Color.blue).cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ButtonStack : View {
    var streamingUrls: ListnStreamingUrls
    
    var body : some View {
        VStack (spacing:5) {
            AppleMusicButton(link: streamingUrls.appleMusic)
            SpotifyButton(link: streamingUrls.spotify)
            ShareButton()
        }.padding(.horizontal)
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

struct FollowButton : View {
    var action: () -> Void
    
    var body: some View {
        Button(action:action) {
            Text("Follow").padding().background(Color.gray).cornerRadius(5)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                FullReviewButton(link:"").previewDisplayName("Full review button")
                RaveButton().previewDisplayName("Rave button")
                SpotifyButton(link: "").previewDisplayName("Spotify button")
                AppleMusicButton(link: "").previewDisplayName("Apple Music button")
                
            }.previewLayout(PreviewLayout.fixed(width: 400, height: 50))
            ButtonStack(streamingUrls: ListnStreamingUrls(appleMusic: "", spotify: "")).padding()
        }
        
    }
}

