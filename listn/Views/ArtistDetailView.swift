//
//  ArtistView.swift
//  listn
//
//  Created by Pierre Rodgers on 4/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct ArtistDetailView: View {
    @ObservedObject var model : ArtistDetailViewModel
    
    
    var body: some View {
        VStack {
            Text(model.artist.name)
            Text(model.artist.streamingUrls.appleMusic)
            Text(model.artist.streamingUrls.spotify)
            
            List(model.reviews, id:\._id) { review in
                VStack {
                    Text(review.score)
                    Text(review.reviewer.name)
                }
                
                
            }
        }.onAppear() {
            self.model.getReviews()
        }
    }
}

/*struct ArtistDetailView: PreviewProvider {
    static var previews: some View {
        ArtistDetailView()
    }
}
*/
