//
//  SearchReviewerRow.swift
//  listn
//
//  Created by Pierre Rodgers on 20/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct SearchReviewerRow: View {
    var reviewer : ListnReviewer
    
    var body: some View {
        HStack{
            Circle().frame(width:60, height:60)
            Text("@\(reviewer.name)")
            Spacer()
        }.frame(maxWidth:.infinity, maxHeight:60)
    }
}

struct SearchReviewerRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchReviewerRow(reviewer: ListnReviewer(forPreview: true))
    }
}
