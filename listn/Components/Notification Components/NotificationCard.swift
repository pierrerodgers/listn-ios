//
//  NotificationCard.swift
//  listn
//
//  Created by Pierre Rodgers on 30/9/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct NotificationCard: View {
    var notification : ListnNotification
    
    var body: some View {
        VStack{
            Text(notification._id)
            Text(notification.actor)
            Text(notification.content)
        }
    }
}
/*
struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCard()
    }
}
*/
