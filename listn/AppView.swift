//
//  AppView.swift
//  listn
//
//  Created by Pierre Rodgers on 5/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

class ShowReviewSheet : ObservableObject {
    @Published var isAddingReview = false
    @Published var albumReviewing : ListnAlbum?
}

struct AppView: View {
    @EnvironmentObject var app : ListnApp
    
    @ObservedObject var showReviewSheet = ShowReviewSheet()
    
    var body: some View {
        print("logged in: \(app.isLoggedIn)")
        if app.isLoading {
            return AnyView(ContentView())

        }
        
        else if app.isLoggedIn == false {
            return AnyView(LoginView( viewModel: LoginViewModel(loginService: app.loginService, app:app)))
        }
        else if app.loginError {
            return AnyView(
                VStack{
                    Text("Error logging in").font(.title)
                    Text("Try restarting the app to try again")
                })
        }
        else {
            return AnyView(
            UIKitTabView {
                FeedView(model: FeedModel(app: app)).tab(title: "Feed")
                SearchView(model: SearchViewModel(app: app)).tab(title:"Search")
                NotificationsView(model: NotificationsViewModel(app: app)).tab(title:"Notifications")
                NavigationView{ProfileView(model: ProfileViewModel(app: app, user: self.app.listnUser!))}.tab(title: "Profile")
            }.environmentObject(showReviewSheet).sheet(isPresented: $showReviewSheet.isAddingReview) {
                AddReviewView(model: AddReviewViewModel(album: self.showReviewSheet.albumReviewing, app: self.app, user: self.app.listnUser!)).environmentObject(self.showReviewSheet)
            })
        }
        
    }
    
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
/*
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
*/
