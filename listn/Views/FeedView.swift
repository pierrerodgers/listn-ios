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
        NavigationView {
            List {
                ForEach(model.reviews.enumerated().map({$0}), id: \.element._id) { index, review in
                    NavigationLink(destination: LazyView(ReviewDetailView(model: ReviewDetailViewModel(review: review, app: self.model.app))) ) {
                        FeedReviewCard(review: review).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).onAppear() {
                            if index == self.model.reviews.count - 10 {
                                self.model.getNextPage()
                            }
                        }
                    }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                }
            }.onAppear() {
                if #available(iOS 14.0, *) {
                    // iOS 14 doesn't have extra separators below the list by default.
                } else {
                    // To remove only extra separators below the list:
                    UITableView.appearance().tableFooterView = UIView()
                }

                // To remove all separators including the actual ones:
                UITableView.appearance().separatorStyle = .none
                UITableViewCell.appearance().selectionStyle = .none
            }.navigationBarTitle("Rave")

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
