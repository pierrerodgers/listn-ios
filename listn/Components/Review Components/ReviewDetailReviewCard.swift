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
    @EnvironmentObject var model : ReviewDetailViewModel
    //let comments : Array<ListnComment>
    
    var body: some View {
        VStack{
            VStack (alignment:.leading){
                HStack{
                    // Reviewer/User image
                    NavigationLink(destination: LazyView(ProfileView(model: ProfileViewModel(app: self.model.app, user: self.review.user)))) {
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
                if(review.isCritic) {
                    FullReviewButton(link: review.link ?? "")
                }

            }.padding(.bottom, 5)
            HStack(spacing:20){
                LikeButton(action:self.model.toggleReviewLike, isLiked: self.$model.isLiked)
                CommentButton(action:{})
                Spacer()
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
