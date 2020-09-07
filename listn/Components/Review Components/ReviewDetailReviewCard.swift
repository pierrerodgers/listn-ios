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
                    }.buttonStyle(PlainButtonStyle())
                    Spacer()
                    Text(review.score).scoreText()
                }
                
                Text(review.text ?? "").fixedSize(horizontal: false, vertical: true)
                if(review.isCritic) {
                    FullReviewButton(link: review.link ?? "")
                }

            }.padding(.bottom, 5)
            HStack(spacing:20){
                LikeButton(action:self.model.toggleReviewLike, isLiked: self.$model.isLiked)
                Text("\(review.likes!)").foregroundColor(.red)
                CommentButton(action:{})
                Spacer()
            }
            ReviewComments()
        }
    }
}

struct ReviewComments : View {
    @EnvironmentObject var model : ReviewDetailViewModel
    @State var commentText : String = ""
    
    var body : some View {
        VStack (alignment:.leading){
            
            ForEach(Array(model.comments.prefix(min(model.comments.count, 5))), id:\._id) { comment in
                VStack(alignment:.leading){
                    Text("@\(comment.username)")
                    Text(comment.commentText).font(.subheadline)
                    Spacer()
                }
            }
            HStack{
                TextField("Add a comment", text: $commentText)
                Button(action: postComment) {
                    Text("Post")
                }
            }
        }
    }
    
    func postComment() {
        if (commentText != "") {
            
            
            let comment = ListnComment(commentText: commentText, reviewCommented: model.review._id!, user: model.app.listnUser!._id, username:model.app.listnUser!.username)
            model.postComment(comment: comment)
            commentText = ""
        }
        
    }
}



struct ReviewDetailReviewCard_Previews: PreviewProvider {
    
    static var previews: some View {
        let review = ListnReview(forPreview: true)

        return ReviewDetailReviewCard(review: review)
    }
}
