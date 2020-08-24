//
//  SearchReviewerRow.swift
//  listn
//
//  Created by Pierre Rodgers on 20/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct SearchUserRow: View {
    var user : ListnUser
    
    var body: some View {
        HStack{
            Circle().frame(width:60, height:60)
            Text("@\(user.name)")
            Spacer()
        }.frame(maxWidth:.infinity, maxHeight:60)
    }
}

struct SearchReviewerRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserRow(user: ListnUser(forPreview: true))
    }
}
