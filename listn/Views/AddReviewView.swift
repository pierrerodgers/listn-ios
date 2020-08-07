//
//  AddReviewView.swift
//  listn
//
//  Created by Pierre Rodgers on 27/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import RealmSwift
import Realm

struct AddReviewView: View {
    @ObservedObject var model : AddReviewViewModel
    
    
    
    var body: some View {
        VStack {
            Text("Add review")
            Text("Album to test review for:")
            Text(model.album.name) + Text (model.album.artist.name)
            Button(action:self.model.postReview) {
                Text("Press to add review")
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
