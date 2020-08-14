//
//  ReviewRow.swift
//  listn
//
//  Created by Pierre Rodgers on 14/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct ReviewRow: View {
    let review : ListnReview
    //let comments : Array<ListnComment>
    
    var body: some View {
        VStack (alignment:.leading){
            HStack{
                // Reviewer/User image
                Circle().frame(width:40, height:40)
                Text("@\(review.username)").font(.system(size: 24))
                Spacer()
                
            }
            Text(review.score).title()
        }
    }
}

struct ReviewRow_Previews: PreviewProvider {
    static var previews: some View {
        let review = ListnCriticReview(forPreview: true)
        return ReviewRow(review: review)
    }
}