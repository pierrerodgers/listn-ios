//
//  FeedModel.swift
//  listn
//
//  Created by Pierre Rodgers on 24/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import Combine

class FeedModel: ObservableObject {
    // MARK: Overview
    /*
        This class should be independent of whatever database mechanism
        I end up using.
     
        It should only handle UI logic
     */
    
    var app : AppData
    
    @Published var reviews : Array<review>
    
    
    
    init(app: AppData) {
        self.app = app
        reviews = app.getLatestReviews()
    }
    
    
    
    
}
