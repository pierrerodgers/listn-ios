//
//  NotificationView.swift
//  listn
//
//  Created by Pierre Rodgers on 30/9/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var model : NotificationsViewModel
    
    var body: some View {
        List(model.notifications, id: \._id){ notification in
            if notification.type == .comment || notification.type == .like {
                NavigationLink(destination:LazyView(ReviewDetailView().environmentObject(ReviewDetailViewModel(reviewId:notification.content, app:model.app)))) {
                    NotificationCard(notification: notification)
                }
            }
            else {
                NotificationCard(notification: notification)
            }
            /*else if notification.type == .follow {
                
            }*/
        }.navigationBarTitle("Notifications").pullToRefresh(isShowing: $model.isLoading, onRefresh: model.refresh)
    }
}
/*
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
*/
