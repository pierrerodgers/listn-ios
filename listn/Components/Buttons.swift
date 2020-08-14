//
//  Buttons.swift
//  listn
//
//  Created by Pierre Rodgers on 14/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct RaveButton: View {
    var body: some View {
        Text("+ rave").title().padding().background(Color(.gray)).cornerRadius(10)
    }
}
struct FullReviewButton : View {
    var link : String
    
    var body: some View {
        Button(action: {}) {
            HStack{
                Image(systemName: "arrow.up.right.square").font(.system(size: 20))
                Text("See full review").font(.system(size: 20))
            }
        }
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FullReviewButton(link:"").previewDisplayName("Full review button")
            RaveButton().previewDisplayName("Rave button")
        }.previewLayout(PreviewLayout.fixed(width: 400, height: 50))
        
    }
}

