//
//  AppView.swift
//  listn
//
//  Created by Pierre Rodgers on 5/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct AppView: View {
    var app : ListnApp
    
    var body: some View {
        UIKitTabView {
            FeedView(model: FeedModel(app: app)).tab(title: "Feed")
            TestSearchView(model: TestSearchViewModel(app: app)).tab(title:"Search")
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
