//
//  ReviewDetailReviewCard.swift
//  listn
//
//  Created by Pierre Rodgers on 14/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReviewDetailReviewCard: View {
    let review : ListnReview
    @EnvironmentObject var app : ListnApp
    //let comments : Array<ListnComment>
    
    var body: some View {
        VStack (alignment:.leading){
            HStack{
                // Reviewer/User image
                NavigationLink(destination: LazyView(ProfileView(model: ProfileViewModel(app: self.app, user: self.review.user)))) {
                    HStack{
                        Circle().frame(width:40, height:40)
                        Text("@\(review.user.username)").title()
                    }
                }.onTapGesture {
                    print("TPped!")
                }.buttonStyle(PlainButtonStyle())
                Spacer()
                Text(review.score).scoreText()
            }
            Text(review.text ?? "")
            Text("Comments to come")
            if(review.isCritic) {
                FullReviewButton(link: review.link ?? "")
            }
        }
    }
}

struct ReviewComments {
    
}



struct ReviewDetailReviewCard_Previews: PreviewProvider {
    
    static var previews: some View {
        let review = ListnReview(forPreview: true)

        return ReviewDetailReviewCard(review: review)
    }
}
