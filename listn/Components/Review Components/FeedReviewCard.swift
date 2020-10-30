//
//  FeedReviewCard.swift
//  listn
//
//  Created by Pierre Rodgers on 13/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedReviewCard: View {
    let review : ListnReview
    
    var body: some View {
        VStack(alignment:.leading, spacing:0){
            HStack(alignment: .top){
                WebImage(url: URL(string:review.album.smallArtwork ?? "")).resizable().placeholder(content: {Rectangle()}).frame(width:130, height: 130).cornerRadius(5)
                //Rectangle().frame(width:200, height:200)
                VStack(alignment:.leading){
                    Text(review.album.name)
                    Text(review.album.artist.name).fontWeight(.light)
                    Spacer()
                    Text(review.score).scoreText()
                    HStack{
                        Circle().frame(width: 30, height: 30)
                        Text("@") + Text(review.user.username)
                    }
                    
                    
                }.padding(.trailing).padding(.vertical).frame(maxHeight:130)
                Spacer()
            }.frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight:130)
            if review.text != nil && review.text != "" {
                Text(review.text!).padding(5).lineLimit(2)
            }
        }.frame(minHeight:130)
    }
}

struct FeedReviewCard_Previews: PreviewProvider {
    
    static var previews: some View {
        let review = ListnReview(forPreview:true)
        return Group{
            FeedReviewCard(review: review).previewLayout(.fixed(width: 414, height: 200))
            
            VStack{
                FeedReviewCard(review: review)
                FeedReviewCard(review: review)
                FeedReviewCard(review: review)
            }.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        }
    }
}


extension ListnAlbum {
    init(forPreview:Bool) {
        self._id = ""
        self.name = "What's Your Pleasure?"
        self.artwork = "https://media.pitchfork.com/photos/5ef619d08813ffa92664e83d/1:1/w_600/What’s%20Your%20Pleasure?_Jessie%20Ware.jpg"
        self.artist = ListnArtist(forPreview: true)
        self.streamingUrls = ListnStreamingUrls(appleMusic: "", spotify: "")
        self.releaseDate = Date()
        self.genres = ["Pop", "Dance"]
    }
}

extension ListnArtist {
    init(forPreview:Bool) {
        self._id = ""
        self.name = "Jessie Ware"
        self.streamingUrls = ListnStreamingUrls(appleMusic: "", spotify: "")
        self.image = ""
    }
}

extension ListnUser {
    init(forPreview:Bool) {
        self._id = ""
        self.name = "pitchfork"
        self.link = "www.pitchfork.com"
        self.username = "pitchfork"
        self.isCritic = true
    }
}
