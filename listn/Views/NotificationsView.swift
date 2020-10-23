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
            Text(notification.content)
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
