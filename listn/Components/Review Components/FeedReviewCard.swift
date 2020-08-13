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
        HStack{
            WebImage(url: URL(string:review.album.smallArtwork ?? "")).resizable().placeholder(content: {Rectangle()}).frame(width:180, height: 180)
            //Rectangle().frame(width:200, height:200)
            VStack(alignment:.leading){
                Text(review.album.name).title()
                Text(review.album.artist.name)
                Spacer()
                Text(review.score).scoreText()
                HStack{
                    Circle().frame(width: 30, height: 30)
                    Text("@") + Text(review.username)
                }
                
            }.padding(.trailing).padding(.vertical)
            Spacer()
        }.frame(width:414, height:200)
    }
}

struct FeedReviewCard_Previews: PreviewProvider {
    
    static var previews: some View {
        let review = ListnCriticReview(forPreview:true)
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

extension ListnCriticReview {
    init(forPreview:Bool) {
        self._id = "1"
        self.reviewer = ListnReviewer(forPreview: true)
        self.album = ListnAlbum(forPreview: true)
        self.date = Date()
        self.reviewType = .critic
        self.score = "90"
    }
}

extension ListnAlbum {
    init(forPreview:Bool) {
        self._id = ""
        self.name = "What's Your Pleasure?"
        self.artwork = "https://media.pitchfork.com/photos/5ef619d08813ffa92664e83d/1:1/w_600/What’s%20Your%20Pleasure?_Jessie%20Ware.jpg"
        self.artist = ListnArtist(forPreview: true)
        self.streamingUrls = ListnStreamingUrls(appleMusic: "", spotify: "")
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

extension ListnReviewer {
    init(forPreview:Bool) {
        self._id = ""
        self.name = "pitchfork"
        self.link = "www.pitchfork.com"
    }
}
