//
//  ListView.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ListView: View {
    
    @ObservedObject var viewModel : ListViewModel
    
    
    var body: some View {
        Text("testing")
        /*List(viewModel.albums) { item in
            Text(item.name)
        }*/
    }
}
/*
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
*/
