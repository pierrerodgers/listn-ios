//
//  FeedView.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import ActivityIndicatorView
import SwiftUIRefresh

struct FeedView: View {
    @ObservedObject var model : FeedModel
    
    var body: some View {
        ZStack {
            
            NavigationView {
                ZStack{

                    List {
                        ForEach(model.reviews.enumerated().map({$0}), id: \.element._id) { index, review in
                            ZStack {
                                FeedReviewCard(review: review).onAppear() {
                                    if index == self.model.reviews.count - 5 {
                                        self.model.getNextPage()
                                    }
                                }
                                NavigationLink(destination: LazyView(ReviewDetailView().environmentObject(ReviewDetailViewModel(review: review, app: self.model.app)) )) {
                                    EmptyView()
                                    }.opacity(0).buttonStyle(PlainButtonStyle())
                            }.listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            
                        }
                        HStack(){
                            Spacer()
                            ActivityIndicatorView(isVisible: $model.isLoading, type: .arcs).frame(width:50, height:50)
                            Spacer()
                        }
                        
                    }.listStyle(PlainListStyle()).pullToRefresh(isShowing: $model.isRefreshing){
                        self.model.refreshUserFeed()
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
                    HStack(alignment:.bottom) {
                        Spacer()
                        VStack(alignment:.trailing) {
                            Spacer()
                            NewRaveButton().padding()
                        }
                    }

                }
            }
            
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
