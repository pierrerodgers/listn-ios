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
    var realm : Realm!
    
    var body: some View {
        Button(action: addReview, label: {Text("Press to test review")})
    }
    
    func addReview() {
    
        let user = realm.objects(User.self).first!
        print(user)
        
        
        let review = UserReview(value:[
            "_id":ObjectId.generate(),
            "album" : ObjectId("5f11194562344c05fa5cd902"),
            "artist" : ObjectId("5f02c6ccd24b0c2255dcbfea"),
            "date" : Date(),
            "score" : "95",
            "text" : "One of my favourite albums of this year",
            "link" : "",
            "_partitionKey": user._partitionKey,
            "user" : try! ObjectId(string:user.user_id)
        ])
        print(review)
            
        try! realm.write {
            self.realm.add(review)
        }
        
    }
}

struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddReviewView()
    }
}
