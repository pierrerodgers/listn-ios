//
//  AddReviewView.swift
//  listn
//
//  Created by Pierre Rodgers on 27/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewReview {
    var score : Int = 0
    var text : String = ""
}

struct AddReviewView: View {
    @ObservedObject var model : AddReviewViewModel
    @State var review  = NewReview()
    
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading) {
                Text("Rave about").title()
                HStack{
                    Spacer()
                    WebImage(url:URL(string: self.model.album.smallArtwork ?? "")).resizable().placeholder(){Rectangle()}.frame(width:300, height:300)
                    Spacer()
                }
                Text(model.album.name).bold()
                Text(model.album.artist.name)
                Divider()
                Text("Score").font(.headline)
                Picker(selection: $review.score, label: Text("Score")) {
                    ForEach(1...100, id:\.self) { score in
                        Text(String(score))
                    }
                }
                TextField("Add details", text: $review.text)
                SaveReviewButton(action:{self.model.postReview(review: self.review)})
            }
        }
    }
    
}
/*
struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddReviewView()
    }
}*/
