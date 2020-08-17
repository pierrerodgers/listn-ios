//
//  ContentView.swift
//  listn
//
//  Created by Pierre Rodgers on 22/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import ActivityIndicatorView

struct ContentView: View {
    @State var loading : Bool = true
    var body: some View {
        ActivityIndicatorView(isVisible: $loading, type: .arcs).frame(width:100, height:100)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
