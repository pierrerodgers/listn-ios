//
//  ReviewDetailView.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct ReviewDetailView: View {
    @State var review : Review
    
    var body: some View {
        Text(review.album!.name ?? "Album")
    }
}
/*
struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetailView()
    }
}
*/
