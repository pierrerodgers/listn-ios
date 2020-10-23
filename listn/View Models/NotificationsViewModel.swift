//
//  NotificationsViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 30/9/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//
import Foundation
import Combine
import SwiftUI

class NotificationsViewModel : ObservableObject {
    var app : ListnApp
    var cancellable : AnyCancellable?

    @Published var notifications : [ListnNotification] = []
    @Published var isLoading: Bool = false
    
    init(app:ListnApp) {
        self.app = app
        self.refresh()
    }
    
    func refresh() {
        isLoading = true
        cancellable = self.app.notificationsPublisher(userId: app.user!._id!.stringValue).receive(on: DispatchQueue.main).sink(receiveCompletion: { completed in
            self.isLoading = false
        }, receiveValue: { notifications in
            self.notifications = notifications
        })
    }
}
