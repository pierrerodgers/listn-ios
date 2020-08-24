//
//  AddReviewView.swift
//  listn
//
//  Created by Pierre Rodgers on 27/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import TextView
import PopupView

struct NewReview {
    var score : Int = 0
    var text : String = ""
}



struct AddReviewView: View {
    @ObservedObject var model : AddReviewViewModel
    @EnvironmentObject var showReviewSheet : ShowReviewSheet
    @State var review  = NewReview()
    
    @State var isEditing : Bool = false
    @State var showPopup = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment:.leading) {
                        if model.inputValid.missingAlbum {
                            Button(action:{
                                self.showPopup = false
                                self.showPopup = true
                            }) {
                                Text("Add album")
                            }
                        }
                        else {
                            HStack{
                                Spacer()
                                WebImage(url:URL(string: self.model.album!.smallArtwork ?? "")).resizable().placeholder(){Rectangle()}.frame(width:300, height:300)
                                Spacer()
                            }
                            Text(model.album!.name).bold()
                            Text(model.album!.artist.name)
                        }
                        Divider()
                        Text("Score").font(.headline)
                        Picker(selection: $review.score, label: Text("Score")) {
                            ForEach(1...100, id:\.self) { score in
                                Text(String(score))
                            }
                        }
                        TextView(text: $review.text, isEditing: $isEditing, placeholder: "Add details").frame(minHeight:500, maxHeight:.infinity)
                        
                    }
                }.navigationBarTitle("Rave about")
                    .navigationBarItems(leading:Button(action:{self.showReviewSheet.isAddingReview = false}){
                        Text("Cancel").foregroundColor(.red)
                    },
                    trailing: SaveReviewButton(action:{
                        self.model.postReview(review: self.review)
                        self.showReviewSheet.isAddingReview = false
                }))
            }.popup(isPresented: $showPopup, view: {
                VStack{
                    Text("This feature not implemented yet!").bold()
                    Text("To review an album, search for it first!")
                }.background(Color.red).frame(width:200, height:100)
            })
        }
    }
    
}
/*
struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddReviewView()
    }
}*/
