//
//  FeedView.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var model : FeedModel
    
    var body: some View {
        List(model.reviews, id:\.reviewer) { review in
            Text(review.album!.name ?? "Album")
        }
    }
}
/*
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
*/
